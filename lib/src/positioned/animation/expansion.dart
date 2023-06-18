part of 'positioned_animator.dart';

final class _Expansion extends PositionedAnimator {
  const _Expansion({super.curve = _defaultCurve});

  @override
  PositionedDialog call(PositionedDialog dialog) {
    final tween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    );

    final expansion = dialog.animation.drive(
      tween.chain(
        CurveTween(curve: curve),
      ),
    );

    return dialog.copyWith(
      child: _EasyExpansionAnimation(
        expansion: expansion,
        child: dialog.child,
      ),
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

    return _EasyDialogExpansionTransition(
      expansion: expansion,
      child: child,
    );
  }
}

class _EasyDialogExpansionTransition extends AnimatedWidget {
  final Widget child;

  const _EasyDialogExpansionTransition({
    required this.child,
    required Animation<double> expansion,
  }) : super(listenable: expansion);

  @override
  Widget build(BuildContext context) {
    final animation = (super.listenable as Animation<double>);

    return ClipRect(
      child: Align(
        heightFactor: animation.value,
        child: child,
      ),
    );
  }
}
