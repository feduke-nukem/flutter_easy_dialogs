part of 'positioned_dismissible.dart';

class _Tap extends EasyDialogDismissible implements PositionedDismissible {
  const _Tap({
    super.onDismissed,
  });

  @override
  Widget decorate(EasyDismissibleData data) {
    return _TapDismissible(
      onDismissed: () {
        data.handleDismiss?.call();
        onDismissed?.call();
      },
      child: data.dialog,
    );
  }
}

class _TapDismissible extends StatefulWidget {
  final Widget child;
  final OnEasyDismissed onDismissed;

  const _TapDismissible({
    required this.child,
    required this.onDismissed,
  });

  @override
  _TapDismissibleState createState() => _TapDismissibleState();
}

class _TapDismissibleState extends State<_TapDismissible>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late final AnimationController _controller = AnimationController(
    duration: animationDuration,
    upperBound: 0.04,
    vsync: this,
  );

  final animationDuration = const Duration(milliseconds: 200);
  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onPanEnd: _onPanEnd,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        // Trigger widget rebuild
        // ignore: no-empty-block
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!mounted) return;

    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) async {
    await _dismiss();
  }

  void _onPanEnd(DragEndDetails details) async {
    await _dismiss();
  }

  Future _dismiss() async {
    if (!mounted) return;

    await _controller.reverse();
    _onDismissed();
  }

  void _onDismissed() {
    widget.onDismissed();
  }
}
