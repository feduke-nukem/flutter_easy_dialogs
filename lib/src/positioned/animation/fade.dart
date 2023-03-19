part of 'easy_positioned_animator.dart';

/// Fade animation.
class _Fade extends EasyPositionedAnimator {
  const _Fade({
    super.curve,
  });

  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    final tween = Tween<double>(begin: 0.0, end: 1.0);

    return _EasyPositionedFadeAnimation(
      opacity: parent.drive(
        tween.chain(
          CurveTween(curve: curve ?? _defaultCurve),
        ),
      ),
      child: child,
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
