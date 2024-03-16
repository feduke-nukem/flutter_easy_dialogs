// ignore_for_file: deprecated_member_use

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

  /// {@template easy_dialog_dismiss.animatedTap}
  /// Tap gesture but with extra `scale in` on tap down animation.
  /// {@endtemplate}
  const factory EasyDialogDismiss.animatedTap({
    Duration duration,
    double pressScale,
    Curve curve,
    OnEasyDismissed? onDismissed,
    EasyWillDismiss? willDismiss,
    HitTestBehavior? behavior,
    bool instantly,
  }) = _AnimatedTap<D>;

  /// {@template easy_dialog_dismiss.tap}
  /// Simple gesture tap dismiss.
  /// {@endtemplate}
  const factory EasyDialogDismiss.tap({
    HitTestBehavior behavior,
    OnEasyDismissed? onDismissed,
    EasyWillDismiss? willDismiss,
    bool instantly,
  }) = _Tap<D>;

  /// {@template easy_dialog_dismiss.swipe}
  /// Horizontal swipe dismissible.
  ///
  /// Simply uses [Dismissible] under the hood.
  /// {@endtemplate}
  const factory EasyDialogDismiss.swipe({
    DismissDirection direction,
    OnEasyDismissed? onDismissed,
    Widget? background,
    Widget? secondaryBackground,
    VoidCallback? onResize,
    Duration? resizeDuration,
    Map<DismissDirection, double> dismissThresholds,
    Duration movementDuration,
    double crossAxisEndOffset,
    DragStartBehavior dragStartBehavior,
    HitTestBehavior behavior,
    DismissUpdateCallback? onUpdate,
    EasyWillDismiss? willDismiss,
    bool instantly,
  }) = _Swipe<D>;

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
        instantly: instantly,
        result: effectiveOnDismissed?.call(),
      );
  }
}

extension EasyDialogDismissX on EasyDialogDismiss {
  T? parent<T extends EasyDialogDismiss>(EasyDialogContext context) =>
      context.getParentDecorationOfType<T>(this);
}

typedef _AnimatedTapBuilder = Widget Function(bool isPressed);

final class _AnimatedTap<D extends EasyDialog> extends EasyDialogDismiss<D> {
  static const _defaultDuration = Duration(milliseconds: 200);
  static const _defaultPressScale = 0.95;
  static const _defaultCurve = Curves.easeOutCubic;
  static const _defaultBehavior = HitTestBehavior.opaque;

  final Duration duration;
  final Curve curve;
  final double pressScale;
  final HitTestBehavior? behavior;

  const _AnimatedTap({
    this.duration = _defaultDuration,
    super.onDismissed,
    super.willDismiss,
    this.pressScale = _defaultPressScale,
    this.curve = _defaultCurve,
    this.behavior = _defaultBehavior,
    super.instantly,
  });

  @override
  Widget call(D dialog) {
    return _AnimatedTapAnimation(
      duration: duration,
      pressScale: pressScale,
      curve: curve,
      onTap: () => handleDismiss(dialog),
      behavior: behavior,
      child: dialog.content,
    );
  }
}

class _AnimatedTapAnimation extends StatefulWidget {
  final double pressScale;
  final GestureTapCallback? onTap;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final HitTestBehavior? behavior;

  const _AnimatedTapAnimation({
    required this.child,
    required this.duration,
    required this.pressScale,
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

  @override
  void didUpdateWidget(_AnimatedTapAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pressScale != widget.pressScale) {
      _calculateScale();
    }
  }

  void _calculateScale() {
    final size = (context.findRenderObject() as RenderBox?)!.size;

    final maxSide = math.max(size.height, size.width);

    _resultScale =
        ((maxSide - (1 - widget.pressScale) * _kReferenceScaleIndent) / maxSide)
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
        onTapCancel: () => setState(() => _isPressed = false),
        behavior: widget.behavior,
        child: widget.builder(_isPressed),
      );
}

const _kReferenceScaleIndent = 200;

final class _Tap<D extends EasyDialog> extends EasyDialogDismiss<D> {
  static const _defaultBehavior = HitTestBehavior.opaque;

  final HitTestBehavior behavior;

  const _Tap({
    this.behavior = _defaultBehavior,
    super.onDismissed,
    super.willDismiss,
    super.instantly,
  });

  @override
  Widget call(D dialog) => GestureDetector(
        onTap: () => handleDismiss(dialog),
        behavior: behavior,
        child: dialog.content,
      );
}

final class _Swipe<D extends EasyDialog> extends EasyDialogDismiss<D> {
  static const _defaultDirection = DismissDirection.horizontal;
  static const _defaultBehavior = HitTestBehavior.deferToChild;
  static const _defaultCrossAxisEndOffset = 0.0;
  static const _defaultDismissThresholds = <DismissDirection, double>{};
  static const _defaultDragStartBehavior = DragStartBehavior.start;
  static const _defaultMovementDuration = Duration(milliseconds: 200);

  final Widget? background;
  final Widget? secondaryBackground;
  final VoidCallback? onResize;
  final Duration? resizeDuration;
  final Map<DismissDirection, double> dismissThresholds;
  final Duration movementDuration;
  final double crossAxisEndOffset;
  final DragStartBehavior dragStartBehavior;
  final HitTestBehavior behavior;
  final DismissUpdateCallback? onUpdate;
  final DismissDirection direction;

  const _Swipe({
    this.direction = _defaultDirection,
    super.onDismissed,
    this.background,
    this.behavior = _defaultBehavior,
    this.crossAxisEndOffset = _defaultCrossAxisEndOffset,
    this.dismissThresholds = _defaultDismissThresholds,
    this.dragStartBehavior = _defaultDragStartBehavior,
    this.movementDuration = _defaultMovementDuration,
    this.onResize,
    this.onUpdate,
    this.resizeDuration,
    this.secondaryBackground,
    super.willDismiss,
    super.instantly = true,
  });

  @override
  Widget call(D dialog) {
    return Dismissible(
      key: UniqueKey(),
      background: background,
      secondaryBackground: secondaryBackground,
      confirmDismiss:
          willDismiss != null ? (_) async => super.willDismiss!() : null,
      onResize: onResize,
      onUpdate: onUpdate,
      onDismissed: (_) => this.handleDismiss(dialog),
      direction: direction,
      resizeDuration: resizeDuration,
      dismissThresholds: dismissThresholds,
      movementDuration: movementDuration,
      crossAxisEndOffset: crossAxisEndOffset,
      dragStartBehavior: dragStartBehavior,
      behavior: behavior,
      child: dialog.content,
    );
  }
}
