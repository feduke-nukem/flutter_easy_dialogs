part of 'positioned_animation.dart';

final class _VerticalSlide extends PositionedAnimation {
  const _VerticalSlide({super.curve = _defaultCurve});

  @override
  Widget call(PositionedDialog dialog) {
    final tween = _createTweenOfPosition(dialog.position);
    final offset = dialog.context.animation.drive(
      tween.chain(
        CurveTween(curve: curve),
      ),
    );

    return _EasyVerticalSlideAnimation(
      offset: offset,
      child: dialog.content,
    );
  }

  Tween<Offset> _createTweenOfPosition(EasyDialogPosition position) {
    return switch (position) {
      EasyDialogPosition.top => Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: const Offset(0.0, 0.0),
        ),
      EasyDialogPosition.bottom => Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, 0.0),
        ),
      EasyDialogPosition.center => Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, 0.0),
        ),
    };
  }
}

class _EasyVerticalSlideAnimation extends AnimatedWidget {
  final Widget child;
  const _EasyVerticalSlideAnimation({
    required this.child,
    required Animation<Offset> offset,
  }) : super(listenable: offset);

  @override
  Widget build(BuildContext context) {
    final offset = listenable as Animation<Offset>;

    return SlideTransition(
      position: offset,
      child: child,
    );
  }
}
