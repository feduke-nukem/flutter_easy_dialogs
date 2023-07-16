part of 'easy_dialogs_controller.dart';

/// {@category Decorations}
/// {@template easy_dialog_dismiss.on_easy_dismiss}
/// #### Dismiss callback.
///
/// It is used to return some result data from the [EasyDialog] via the
/// callback.
/// {@endtemplate}
typedef OnEasyDismissed = FutureOr<Object?> Function();

/// {@template easy_dialog_dismiss.easy_will_dismiss}
/// #### Callback that fires when dialog is about to be dismissed.
///
/// If it returns `false`, the dialog will not be dismissed.
///
/// It is quite similar to [WillPopCallback].
/// {@endtemplate}
typedef EasyWillDismiss = FutureOr<bool> Function();

/// {@category Decorations}
/// {@category Migration guide from 2.x to 3.x}
/// The main purpose is to make [EasyDialog] dismissible.
///
/// See also:
/// * [EasyDialogAnimation] for providing animations to the dialog.
abstract base class EasyDialogDismiss<D extends EasyDialog>
    extends EasyDialogDecoration<D> {
  /// {@macro easy_dialog_dismiss.on_easy_dismiss}
  final OnEasyDismissed? onDismissed;

  /// {@macro easy_dialog_dismiss.easy_will_dismiss}
  final EasyWillDismiss? willDismiss;

  /// If `true`, the dialog will be dismissed instantly without any animation.
  final bool instantly;

  /// Creates an instance of [EasyDialogDismiss].
  const EasyDialogDismiss({
    this.onDismissed,
    this.willDismiss,
    this.instantly = false,
  });

  /// Tap gesture but with extra `scale in` on tap down animation.
  const factory EasyDialogDismiss.animatedTap({
    Duration duration,
    double pressedScale,
    Curve curve,
    OnEasyDismissed? onDismissed,
    EasyWillDismiss? willDismiss,
    HitTestBehavior? behavior,
  }) = _AnimatedTap<D>;

  /// Simple gesture tap dismiss.
  const factory EasyDialogDismiss.tap({
    HitTestBehavior behavior,
    OnEasyDismissed? onDismissed,
    EasyWillDismiss? willDismiss,
  }) = _Tap<D>;

  /// ### Handler for dismissing the dialog.
  ///
  /// If [willDismiss] returns `false`, the dialog will not be dismissed.
  ///
  /// If [onDismissed] or [willDismiss] is `null`, and there are any other
  /// [EasyDialogDismiss] within [EasyDialogContext], values from
  /// the context will be taken instead.
  @protected
  Future<void> handleDismiss(D dialog) async {
    final parentDismiss = parent(dialog.context);
    final effectiveWillDismiss = willDismiss ?? parentDismiss?.willDismiss;
    final effectiveOnDismissed = onDismissed ?? parentDismiss?.onDismissed;

    if (await effectiveWillDismiss?.call() ?? true)
      dialog.context.hideDialog(
        result: effectiveOnDismissed?.call(),
        instantly: instantly,
      );
  }
}

extension EasyDialogDismissX on EasyDialogDismiss {
  T? parent<T extends EasyDialogDismiss>(EasyDialogContext context) =>
      context.getParentDecorationOfType<T>(this);
}

typedef _AnimatedTapBuilder = Widget Function(bool isPressed);

final class _AnimatedTap<D extends EasyDialog> extends EasyDialogDismiss<D> {
  final Duration duration;
  final Curve curve;
  final double pressedScale;
  final HitTestBehavior? behavior;

  const _AnimatedTap({
    this.duration = const Duration(milliseconds: 200),
    super.onDismissed,
    super.willDismiss,
    this.pressedScale = 0.95,
    this.curve = Curves.easeOutCubic,
    this.behavior,
  });

  @override
  Widget call(D dialog) {
    return _AnimatedTapAnimation(
      duration: duration,
      pressedScale: pressedScale,
      curve: curve,
      onTap: () => handleDismiss(dialog),
      behavior: behavior,
      child: dialog.content,
    );
  }
}

class _AnimatedTapAnimation extends StatefulWidget {
  final double pressedScale;
  final GestureTapCallback? onTap;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final HitTestBehavior? behavior;

  const _AnimatedTapAnimation({
    required this.child,
    required this.duration,
    required this.pressedScale,
    required this.curve,
    this.onTap,
    this.behavior,
  });

  @override
  State<_AnimatedTapAnimation> createState() => _AnimatedTapAnimationState();
}

class _AnimatedTapAnimationState extends State<_AnimatedTapAnimation> {
  double _resultScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return _TapDetector(
      builder: (isPressed) => TweenAnimationBuilder(
        tween: Tween<double>(begin: 1.0, end: isPressed ? _resultScale : 1.0),
        duration: widget.duration,
        curve: widget.curve,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: widget.child,
      ),
      onTap: widget.onTap?.call,
      behavior: widget.behavior,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(_calculateScale);
      }
    });
  }

  // coverage:ignore-start
  @override
  void didUpdateWidget(_AnimatedTapAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pressedScale != widget.pressedScale) {
      _calculateScale();
    }
  }
  // coverage:ignore-end

  void _calculateScale() {
    final size = (context.findRenderObject() as RenderBox?)!.size;

    final maxSide = math.max(size.height, size.width);

    _resultScale =
        ((maxSide - (1 - widget.pressedScale) * _kReferenceScaleIndent) /
                maxSide)
            .clamp(0.0, 1.0);
  }
}

class _TapDetector extends StatefulWidget {
  final VoidCallback? onTap;
  final HitTestBehavior? behavior;

  final _AnimatedTapBuilder builder;

  const _TapDetector({
    required this.builder,
    this.onTap,
    this.behavior,
  });

  @override
  _TapDetectorState createState() => _TapDetectorState();
}

class _TapDetectorState extends State<_TapDetector> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTap: widget.onTap,
        // coverage:ignore-start
        onTapCancel: () => setState(() => _isPressed = false),
        // coverage:ignore-end
        behavior: widget.behavior,
        child: widget.builder(_isPressed),
      );
}

const _kReferenceScaleIndent = 200;

final class _Tap<D extends EasyDialog> extends EasyDialogDismiss<D> {
  final HitTestBehavior behavior;

  const _Tap({
    this.behavior = HitTestBehavior.opaque,
    super.onDismissed,
    super.willDismiss,
  });

  @override
  Widget call(D dialog) => GestureDetector(
        onTap: () => handleDismiss(dialog),
        behavior: behavior,
        child: dialog.content,
      );
}
