part of 'positioned_animation.dart';

final class _Fade extends PositionedAnimation {
  const _Fade({super.curve = _defaultCurve});

  @override
  Widget call(EasyDialogContext<PositionedDialog> context) {
    final tween = Tween<double>(begin: 0.0, end: 1.0);

    return _EasyPositionedFadeAnimation(
      opacity: context.animation.drive(
        tween.chain(
          CurveTween(curve: curve),
        ),
      ),
      child: context.content,
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
