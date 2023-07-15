part of 'easy_dialogs_controller.dart';

const _defaultCurve = Curves.fastLinearToSlowEaseIn;

/// {@category Decorations}
/// Base class of animator for dialogs.
///
/// Its main purpose is to apply an animation effect to the provided
/// [EasyDialog].
///
/// See also:
/// * [EasyDialogAnimationConfiguration].
/// * [EasyDialogsController].
/// * [EasyDialog].
/// * [EasyDialogDecoration].
/// * [EasyDialogDismiss].
abstract base class EasyDialogAnimation<D extends EasyDialog>
    extends EasyDialogDecoration<D> {
  /// Desired curve to be applied to the animation.
  final Curve curve;

  /// @nodoc
  const EasyDialogAnimation({this.curve = Curves.linear});

  /// Simple fade transition.
  const factory EasyDialogAnimation.fade({Curve curve}) = _Fade<D>;

  /// Expansion from inside to outside.
  const factory EasyDialogAnimation.expansion({Curve curve}) = _Expansion<D>;
}

final class _Fade<D extends EasyDialog> extends EasyDialogAnimation<D> {
  const _Fade({super.curve = _defaultCurve});

  @override
  Widget call(D dialog) {
    final tween = Tween<double>(begin: 0.0, end: 1.0);

    return _EasyPositionedFadeAnimation(
      opacity: dialog.context.animation.drive(
        tween.chain(
          CurveTween(curve: curve),
        ),
      ),
      child: dialog.content,
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

final class _Expansion<D extends EasyDialog> extends EasyDialogAnimation<D> {
  const _Expansion({super.curve = _defaultCurve});

  @override
  Widget call(D dialog) {
    final tween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    );

    final expansion = dialog.context.animation.drive(
      tween.chain(
        CurveTween(curve: curve),
      ),
    );

    return _EasyExpansionAnimation(
      expansion: expansion,
      child: dialog.content,
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
