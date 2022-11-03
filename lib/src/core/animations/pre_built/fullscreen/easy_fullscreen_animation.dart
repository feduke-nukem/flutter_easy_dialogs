import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/animations/helper/multiply_animation.dart';
import 'package:flutter_easy_dialogs/src/core/animations/widgets/fullscreen_blur.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs_exception.dart';

class EasyFullScreenAnimation extends EasyAnimation {
  final EasyFullScreenContentAnimationType contentAnimationType;
  final EasyFullScreenBackgroungAnimationType backgroungAnimationType;
  final IEasyAnimator? customContentAnimation;
  final IEasyAnimator? customBackgroundAnimation;
  final Color? backgroundColor;

  EasyFullScreenAnimation({
    required this.backgroungAnimationType,
    required this.contentAnimationType,
    this.customBackgroundAnimation,
    this.customContentAnimation,
    this.backgroundColor,
    super.curve,
  });

  @override
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  }) {
    final content =
        customContentAnimation?.animate(parent: parent, child: child) ??
            _animateChild(child: child, parent: parent);

    return customBackgroundAnimation?.animate(child: child, parent: parent) ??
        _animateBackground(child: content, parent: parent);
  }

  Widget _animateBackground({
    required Animation<double> parent,
    required Widget child,
  }) {
    switch (backgroungAnimationType) {
      case EasyFullScreenBackgroungAnimationType.blur:
        return _animateBlurBackground(content: child, parent: parent);

      case EasyFullScreenBackgroungAnimationType.fade:
        return AnimatedBuilder(
          animation: parent,
          builder: (_, child) => FullScreenBlur(
            backgorundColor: backgroundColor ?? Colors.black,
            blur: 0.5,
            opacity: CurvedAnimation(
              curve: Curves.easeInOut,
              parent: parent,
            ).value,
            child: child!,
          ),
          child: child,
        );
      case EasyFullScreenBackgroungAnimationType.none:
        return child;

      default:
        Error.throwWithStackTrace(
          FlutterEasyDialogsError(
            message: 'no case for $backgroungAnimationType',
          ),
          StackTrace.current,
        );
    }
  }

  Widget _animateChild({
    required Animation<double> parent,
    required Widget child,
  }) {
    switch (contentAnimationType) {
      case EasyFullScreenContentAnimationType.bounce:
        return _animateBounceChild(child: child, parent: parent);
      case EasyFullScreenContentAnimationType.fade:
        return FadeTransition(
          opacity: CurvedAnimation(
            curve: Curves.easeInOutCubic,
            parent: parent,
          ),
          child: child,
        );

      case EasyFullScreenContentAnimationType.expansion:
        return _animateExpansionChild(parent: parent, child: child);
      case EasyFullScreenContentAnimationType.none:
        return child;

      default:
        Error.throwWithStackTrace(
          FlutterEasyDialogsError(message: 'no case for $contentAnimationType'),
          StackTrace.current,
        );
    }
  }

  Widget _animateBlurBackground({
    required Animation<double> parent,
    required Widget content,
  }) {
    final blurTween = Tween<double>(begin: 5.0, end: 8.0);
    final fadeTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    );
    const fadeInterval = Interval(
      0.0,
      0.35,
      curve: Curves.easeInOut,
    );
    final fadeAnimation = CurvedAnimation(
      parent: parent,
      curve: fadeInterval,
    ).drive(fadeTween);

    return AnimatedBuilder(
      animation: parent,
      builder: (_, child) => FullScreenBlur(
        backgorundColor: backgroundColor,
        opacity: fadeAnimation.value,
        blur: (curve != null
                ? parent.drive(
                    blurTween.chain(
                      CurveTween(curve: curve!),
                    ),
                  )
                : blurTween.animate(parent))
            .value,
        child: child!,
      ),
      child: content,
    );
  }

  Widget _animateBounceChild({
    required Animation<double> parent,
    required Widget child,
  }) {
    final scaleUpChildTween = Tween<double>(
      begin: 0.3,
      end: 1.5,
    );

    final scaleDownChildTween = Tween<double>(
      begin: 1.0,
      end: 1.0 / 1.5,
    );
    const scaleUpChildInterval = Interval(
      0.0,
      0.5,
      curve: Curves.bounceIn,
    );
    const scaleDownChildInterval = Interval(
      0.5,
      1,
      curve: Curves.bounceOut,
    );
    const fadeInterval = Interval(
      0.0,
      0.25,
      curve: Curves.easeInOut,
    );
    final fadeAnimation = CurvedAnimation(
      parent: parent,
      curve: fadeInterval,
    ).drive(
      Tween<double>(
        begin: 0.3,
        end: 1.0,
      ),
    );

    final scaleUpAnimation = CurvedAnimation(
      parent: parent,
      curve: scaleUpChildInterval,
    ).drive(scaleUpChildTween);

    final scaleDownAnimation = CurvedAnimation(
      parent: parent,
      curve: scaleDownChildInterval,
    ).drive(scaleDownChildTween);

    final scaleAnimation = MultiplyAnimation(
      first: scaleUpAnimation,
      next: scaleDownAnimation,
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }

  Widget _animateExpansionChild({
    required Animation<double> parent,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: parent,
      builder: (_, child) => Center(
        child: ClipRect(
          child: Align(
            heightFactor: parent
                .drive(
                  Tween<double>(begin: 0.0, end: 1.0).chain(
                    CurveTween(
                      curve: Curves.easeInCubic,
                    ),
                  ),
                )
                .value,
            child: child!,
          ),
        ),
      ),
      child: child,
    );
  }
}
