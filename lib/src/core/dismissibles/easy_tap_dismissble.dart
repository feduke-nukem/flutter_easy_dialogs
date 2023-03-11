import 'package:flutter/cupertino.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/easy_dismissible.dart';

/// Animated tap dismissible
class EasyTapDismissible extends EasyDismissible {
  const EasyTapDismissible({
    required super.onDismissed,
  });

  @override
  Widget makeDismissible(Widget child) {
    return _TapDismissible(
      onDismissed: onDismissed,
      child: child,
    );
  }
}

class _TapDismissible extends StatefulWidget {
  final Widget child;
  final EasyDismissCallback onDismissed;

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
    vsync: this,
    duration: animationDuration,
    upperBound: 0.04,
  );

  final animationDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    widget.onDismissed();
  }
}
