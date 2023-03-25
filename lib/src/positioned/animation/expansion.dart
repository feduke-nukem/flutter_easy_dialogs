part of 'positioned_animator.dart';

class _Expansion extends PositionedAnimator {
  const _Expansion({super.curve});

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    final tween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    );

    final expansion = data.parent.drive(
      tween.chain(
        CurveTween(curve: curve ?? _defaultCurve),
      ),
    );

    return _EasyExpansionAnimation(
      expansion: expansion,
      child: data.dialog,
    );
  }
}

class _EasyExpansionAnimation extends AnimatedWidget {
  final Widget child;

  const _EasyExpansionAnimation({
    required this.child,
    required Animation<double> expansion,
  }) : super(listenable: expansion);

  @override
  Widget build(BuildContext context) {
    final expansion = listenable as Animation<double>;

    return EasyDialogExpansionTransition(
      expansion: expansion,
      child: child,
    );
  }
}
