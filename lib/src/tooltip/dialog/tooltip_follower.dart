part of 'tooltip_dialog.dart';

/// Keeps the tooltip attached to its target and within the screen.
///
/// Hides the dialog when the target is unmounted.
class _TooltipFollower extends StatefulWidget {
  final TooltipDialog dialog;
  final Widget child;

  const _TooltipFollower({
    required this.dialog,
    required this.child,
  });

  @override
  State<_TooltipFollower> createState() => _TooltipFollowerState();
}

class _TooltipFollowerState extends State<_TooltipFollower> {
  final _shift = ValueNotifier(Offset.zero);
  // Cached: ancestors can't be looked up in dispose.
  late final _registry = _TooltipTargetRegistry.of(context);
  late final _target = _registry.latest(widget.dialog.targetId);

  @override
  Widget build(BuildContext context) {
    final target = _target;
    if (target == null) return const SizedBox.shrink();

    final dialog = widget.dialog;

    return _TooltipLayout(
      target: target,
      alignment: dialog.alignment,
      followerAnchor: dialog.followerAnchor,
      offset: dialog.offset,
      margin: (MediaQuery.maybePaddingOf(context) ?? EdgeInsets.zero) +
          TooltipDialog.screenMargin,
      shift: _shift,
      child: CompositedTransformFollower(
        link: target.link,
        showWhenUnlinked: false,
        targetAnchor: dialog.alignment,
        followerAnchor: dialog.followerAnchor,
        offset: dialog.offset + _shift.value,
        child: _TooltipShiftScope(shift: _shift, child: widget.child),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _registry.addListener(_onTargetsChanged);

    if (_target != null) return;

    FlutterError.reportError(
      FlutterErrorDetails(
        exception: FlutterError(
          '$EasyTooltipTarget with id: ${widget.dialog.targetId} is not mounted',
        ),
        library: 'flutter_easy_dialogs',
      ),
    );
    _onTargetsChanged();
  }

  @override
  void dispose() {
    _registry.removeListener(_onTargetsChanged);
    _shift.dispose();
    super.dispose();
  }

  // Targets change while the tree is built or unmounted. Hiding instantly
  // changes the animation, and AnimatedBuilder-based decorations would call
  // setState on a locked tree, so hide after the frame.
  void _onTargetsChanged() =>
      SchedulerBinding.instance.addPostFrameCallback((_) {
        final dialog = widget.dialog;
        if (!mounted || dialog._shared.hiding) return;

        if (!_registry.contains(dialog.targetId, _target)) {
          dialog.context.hideDialog(instantly: true);
        }
      });
}

class _TooltipShiftScope extends InheritedWidget {
  final ValueListenable<Offset> shift;

  const _TooltipShiftScope({
    required this.shift,
    required super.child,
  });

  @override
  bool updateShouldNotify(_TooltipShiftScope oldWidget) =>
      oldWidget.shift != shift;
}

class _ZeroShift implements ValueListenable<Offset> {
  const _ZeroShift();

  @override
  Offset get value => Offset.zero;

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}

class _TooltipLayout extends SingleChildRenderObjectWidget {
  final _EasyTooltipTargetState target;
  final Alignment alignment;
  final Alignment followerAnchor;
  final Offset offset;
  final EdgeInsets margin;
  final ValueNotifier<Offset> shift;

  const _TooltipLayout({
    required this.target,
    required this.alignment,
    required this.followerAnchor,
    required this.offset,
    required this.margin,
    required this.shift,
    required CompositedTransformFollower super.child,
  });

  @override
  _RenderTooltipLayout createRenderObject(BuildContext context) =>
      _RenderTooltipLayout(
        target: target,
        alignment: alignment,
        followerAnchor: followerAnchor,
        offset: offset,
        margin: margin,
        shift: shift,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTooltipLayout renderObject,
  ) {
    renderObject
      ..target = target
      ..alignment = alignment
      ..followerAnchor = followerAnchor
      ..offset = offset
      ..margin = margin
      ..shift = shift
      ..markNeedsLayout();
  }
}

/// Fills the overlay and lays out the follower so it fits the screen.
///
/// shortcut: the fit is computed on layout only, so it is not updated when
/// the target moves without relayout of the tooltip (e.g. horizontal scroll).
class _RenderTooltipLayout extends RenderProxyBox {
  _EasyTooltipTargetState target;
  Alignment alignment;
  Alignment followerAnchor;
  Offset offset;
  EdgeInsets margin;
  ValueNotifier<Offset> shift;

  _RenderTooltipLayout({
    required this.target,
    required this.alignment,
    required this.followerAnchor,
    required this.offset,
    required this.margin,
    required this.shift,
  });

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  void performLayout() {
    size = constraints.biggest;
    final follower = child! as RenderFollowerLayer;
    final bounds = margin.deflateRect(Offset.zero & size);
    final targetRect = _targetRect();

    // The width is limited by the space next to the target, so the content
    // wraps instead of overlapping the target.
    final maxWidth = switch (targetRect) {
      Rect t when alignment.y == 0.0 && alignment.x < 0.0 =>
        t.left - bounds.left - offset.dx.abs(),
      Rect t when alignment.y == 0.0 && alignment.x > 0.0 =>
        bounds.right - t.right - offset.dx.abs(),
      _ => bounds.width,
    };

    follower.layout(
      BoxConstraints.loose(
        Size(math.max(0.0, maxWidth), math.max(0.0, bounds.height)),
      ),
      parentUsesSize: true,
    );

    var shift = Offset.zero;

    if (targetRect != null) {
      final childSize = follower.size;
      final desired = alignment.withinRect(targetRect) -
          followerAnchor.alongSize(childSize) +
          offset;
      // Shift only along the target's side, so the target is not covered.
      shift = Offset(
        alignment.y != 0.0 || alignment.x == 0.0
            ? _fit(desired.dx, childSize.width, bounds.left, bounds.right) -
                desired.dx
            : 0.0,
        alignment.y == 0.0
            ? _fit(desired.dy, childSize.height, bounds.top, bounds.bottom) -
                desired.dy
            : 0.0,
      );
    }

    this.shift.value = shift;
    follower.offset = offset + shift;
  }

  static double _fit(double start, double extent, double min, double max) =>
      math.max(min, math.min(start, max - extent));

  Rect? _targetRect() {
    final box = target.mounted ? target.box : null;
    if (box == null || !box.attached || !box.hasSize) return null;

    Rect? rect;
    // The target is not a child, so its geometry may only be read in a layout
    // callback (like LayoutBuilder does). It is laid out already: the overlay
    // lays out the app below the tooltip first.
    invokeLayoutCallback<BoxConstraints>(
      (_) => rect = MatrixUtils.transformRect(
        box.getTransformTo(this),
        Offset.zero & box.size,
      ),
    );

    return rect;
  }
}
