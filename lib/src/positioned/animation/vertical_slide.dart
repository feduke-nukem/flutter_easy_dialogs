part of 'positioned_animator.dart';

class _VerticalSlide extends PositionedAnimator {
  const _VerticalSlide({super.curve});

  @override
  Widget decorate(PositionedAnimatorData data) {
    final tween = _createTweenOfPosition(data.position);
    final offset = data.parent.drive(
      tween.chain(
        CurveTween(curve: curve ?? _defaultCurve),
      ),
    );

    return _EasyVerticalSlideAnimation(
      offset: offset,
      child: data.dialog,
    );
  }

  Tween<Offset> _createTweenOfPosition(EasyDialogPosition position) {
    switch (position) {
      case EasyDialogPosition.top:
        return Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: const Offset(0.0, 0.0),
        );

      case EasyDialogPosition.bottom:
        return Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, 0.0),
        );

      case EasyDialogPosition.center:
        return Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, 0.0),
        );
    }
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
