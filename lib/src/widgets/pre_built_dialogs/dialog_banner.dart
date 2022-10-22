import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_animation.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_animation_type.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_theme.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_transition.dart';

const _kDuration = Duration(milliseconds: 300);
const _kReverseDuration = Duration(milliseconds: 300);
const _kCurve = Curves.easeInOutCubic;

/// Dialog banner
class DialogBanner extends StatefulWidget {
  /// Content
  final Widget child;

  /// Should auto hide banner after [EasyDialogsThemeData]'s duration
  final bool autoHide;

  /// Animation duration
  final Duration? duration;

  /// Animation reverse duration
  final Duration? reverseDuration;

  final Curve? curve;

  /// Animation type
  final EasyDialogsAnimationType animationType;

  /// Creates instance of [DialogBanner]
  const DialogBanner({
    required this.child,
    this.duration,
    this.reverseDuration,
    this.autoHide = false,
    this.animationType = EasyDialogsAnimationType.slide,
    this.curve,
    super.key,
  });

  @override
  State<DialogBanner> createState() => _DialogBannerState();
}

class _DialogBannerState extends State<DialogBanner>
    with SingleTickerProviderStateMixin {
  late EasyDialogsThemeData _theme;

  late final _animationController = AnimationController(
    vsync: this,
    duration: widget.duration ?? _kDuration,
    reverseDuration: widget.reverseDuration ?? _kReverseDuration,
  );

  late final EasyDialogsAnimation _animation;

  @override
  void initState() {
    super.initState();

    _animation = _createAnimation();
    if (widget.autoHide) {
      _animationController.addStatusListener(_animationStatusListener);
    }
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    _theme = EasyDialogsTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: EasyDialogsTransition(
          animation: _animation,
          child: widget.child,
        ),
      ),
    );
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final reverseDuration =
          (widget.reverseDuration ?? _kReverseDuration) * 1.5;
      final dismissDuration = _theme.modalBannerDuration - reverseDuration;

      Future.delayed(
        dismissDuration,
        () {
          if (!mounted) return;

          _animationController.reverse();
        },
      );
    }
  }

  EasyDialogsAnimation _createAnimation() {
    switch (widget.animationType) {
      case EasyDialogsAnimationType.slide:
        return EasyDialogsSlideAnimation(
          parent: _animationController,
          begin: const Offset(0, -1.0),
          end: const Offset(0, -0.5),
          curve: widget.curve ?? _kCurve,
        );
      case EasyDialogsAnimationType.fade:
        return EasyDialogsFadeAnimation(
          parent: _animationController,
          begin: 0,
          end: 1.0,
          curve: widget.curve ?? _kCurve,
        );
      default:
        throw Exception('no case for $this');
    }
  }
}
