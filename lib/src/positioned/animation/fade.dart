part of 'positioned_animator.dart';

class _Fade extends PositionedAnimator {
  const _Fade({super.curve});

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    final tween = Tween<double>(begin: 0.0, end: 1.0);

    return _EasyPositionedFadeAnimation(
      opacity: data.parent.drive(
        tween.chain(
          CurveTween(curve: curve ?? _defaultCurve),
        ),
      ),
      child: data.dialog,
    );
  }
}

class _EasyPositionedFadeAnimation extends AnimatedWidget {
  final Widget child;

  const _EasyPositionedFadeAnimation({
    required Animation<double> opacity,
    required this.child,
  }) : super(listenable: opacity);

  @override
  Widget build(BuildContext context) {
    final opacity = listenable as Animation<double>;

    final transition = FadeTransition(
      opacity: opacity,
      child: child,
    );

    return transition;
  }
}
