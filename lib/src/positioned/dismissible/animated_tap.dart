part of 'positioned_dismissible.dart';

final class _AnimatedTap extends PositionedDismissible {
  const _AnimatedTap({
    this.duration = const Duration(milliseconds: 200),
    super.onDismissed,
    super.hideOnDismiss,
  });

  final Duration duration;

  @override
  Widget call(PositionedDialog dialog) {
    return _AnimatedTapDismissible(
      onDismissed: () => handleDismiss(dialog),
      duration: duration,
      child: dialog.child,
    );
  }
}

class _AnimatedTapDismissible extends StatefulWidget {
  final Widget child;
  final OnEasyDismissed onDismissed;
  final Duration duration;

  const _AnimatedTapDismissible({
    required this.child,
    required this.onDismissed,
    required this.duration,
  });

  @override
  _AnimatedTapDismissibleState createState() => _AnimatedTapDismissibleState();
}

class _AnimatedTapDismissibleState extends State<_AnimatedTapDismissible>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late final AnimationController _controller = AnimationController(
    duration: animationDuration,
    upperBound: 0.04,
    vsync: this,
  );

  late final animationDuration = widget.duration;
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
      // ignore these lines as they are barely testable
      // coverage:ignore-start
      if (mounted) {
        // Trigger widget rebuild
        // ignore: no-empty-block
        setState(() {});
      }
      // coverage:ignore-end
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
    // ignore this line as it is barely testable
    // coverage:ignore-file

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
