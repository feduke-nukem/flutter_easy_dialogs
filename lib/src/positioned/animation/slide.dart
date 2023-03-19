part of 'easy_positioned_animator.dart';

/// Vertical slide animation.
class _Slide extends EasyPositionedAnimator {
  /// Creates an instance of [_Slide].
  const _Slide({
    super.curve,
  });

  @override
  Widget animate({
    required Animation<double> parent,
    required Widget child,
    EasyDialogPosition position = EasyDialogPosition.top,
  }) {
    final tween = _createTweenOfPosition(position);
    final offset = parent.drive(
      tween.chain(
        CurveTween(curve: curve ?? _defaultCurve),
      ),
    );

    return _EasyVerticalSlideAnimation(
      offset: offset,
      child: child,
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
