part of 'easy_positioned_animator.dart';

/// Expansion animation.
class _Expansion extends EasyPositionedAnimator {
  /// Creates an instance of [_Expansion].
  const _Expansion({
    super.curve,
  });

  @override
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  }) {
    final tween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    );

    final expansion = parent.drive(
      tween.chain(
        CurveTween(curve: curve ?? _defaultCurve),
      ),
    );

    return _EasyExpansionAnimation(
      expansion: expansion,
      child: child,
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
