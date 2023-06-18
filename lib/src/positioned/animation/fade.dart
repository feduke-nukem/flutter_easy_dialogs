part of 'positioned_animator.dart';

final class _Fade extends PositionedAnimator {
  const _Fade({super.curve = _defaultCurve});

  @override
  PositionedDialog call(PositionedDialog dialog) {
    final tween = Tween<double>(begin: 0.0, end: 1.0);

    return dialog.copyWith(
      child: _EasyPositionedFadeAnimation(
        opacity: dialog.animation.drive(
          tween.chain(
            CurveTween(curve: curve),
          ),
        ),
        child: dialog.child,
      ),
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
