part of 'tooltip_dialog.dart';

/// Marks the area where a [TooltipDialog] with the same
/// [TooltipDialog.targetId] can be shown.
///
/// Must be placed below [FlutterEasyDialogs].
///
/// If several targets with the same [id] are mounted (e.g. the same screen
/// is pushed twice), the most recently mounted one is used.
class EasyTooltipTarget extends StatefulWidget {
  /// Identifier used by [TooltipDialog.targetId].
  final Object id;

  /// Child widget.
  final Widget child;

  /// Creates an instance of [EasyTooltipTarget].
  const EasyTooltipTarget({
    required this.id,
    required this.child,
    super.key,
  });

  @override
  State<EasyTooltipTarget> createState() => _EasyTooltipTargetState();
}

class _EasyTooltipTargetState extends State<EasyTooltipTarget> {
  // Cached: ancestors can't be looked up in dispose.
  late final _registry = _TooltipTargetRegistry.of(context);

  final link = LayerLink();

  RenderBox? get box => context.findRenderObject() as RenderBox?;

  @override
  Widget build(BuildContext context) =>
      CompositedTransformTarget(link: link, child: widget.child);

  @override
  void initState() {
    super.initState();
    _registry.add(widget.id, this);
  }

  @override
  void didUpdateWidget(covariant EasyTooltipTarget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id == widget.id) return;

    _registry
      ..remove(oldWidget.id, this)
      ..add(widget.id, this);
  }

  @override
  void dispose() {
    _registry.remove(widget.id, this);
    super.dispose();
  }
}

/// Provides the registry of mounted [EasyTooltipTarget]s to its subtree.
///
/// It is a part of [FlutterEasyDialogs], so targets and tooltips (in its
/// overlay) share the same registry.
class TooltipTargetsScope extends StatefulWidget {
  /// Child widget.
  final Widget child;

  /// @nodoc
  const TooltipTargetsScope({required this.child, super.key});

  @override
  State<TooltipTargetsScope> createState() => _TooltipTargetsScopeState();
}

class _TooltipTargetsScopeState extends State<TooltipTargetsScope> {
  final _registry = _TooltipTargetRegistry();

  @override
  Widget build(BuildContext context) =>
      _TooltipTargetsInherited(registry: _registry, child: widget.child);

  @override
  void dispose() {
    _registry.dispose();
    super.dispose();
  }
}

class _TooltipTargetsInherited extends InheritedWidget {
  final _TooltipTargetRegistry registry;

  const _TooltipTargetsInherited({
    required this.registry,
    required super.child,
  });

  @override
  bool updateShouldNotify(_TooltipTargetsInherited oldWidget) =>
      oldWidget.registry != registry;
}

/// Notifies on every change of mounted targets.
class _TooltipTargetRegistry extends ChangeNotifier {
  final _targets = <Object, List<_EasyTooltipTargetState>>{};

  static _TooltipTargetRegistry of(BuildContext context) {
    final scope =
        context.getInheritedWidgetOfExactType<_TooltipTargetsInherited>();

    if (scope == null) {
      throw FlutterError(
        '$EasyTooltipTarget and $TooltipDialog must be used below '
        'FlutterEasyDialogs',
      );
    }

    return scope.registry;
  }

  _EasyTooltipTargetState? latest(Object id) => _targets[id]?.last;

  bool contains(Object id, _EasyTooltipTargetState? target) =>
      _targets[id]?.contains(target) ?? false;

  void add(Object id, _EasyTooltipTargetState target) {
    (_targets[id] ??= []).add(target);
    notifyListeners();
  }

  void remove(Object id, _EasyTooltipTargetState target) {
    final targets = _targets[id]?..remove(target);
    if (targets?.isEmpty ?? false) _targets.remove(id);
    notifyListeners();
  }
}
