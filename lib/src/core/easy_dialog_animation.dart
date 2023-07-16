part of 'easy_dialogs_controller.dart';

const _defaultCurve = Curves.fastLinearToSlowEaseIn;
const _defaultBackgroundColor = Color.fromARGB(44, 117, 116, 116);
const _defaultBlurCurve = Curves.easeInOut;
const _defaultBlur = 0.5;

/// {@category Decorations}
/// {@category Migration guide from 2.x to 3.x}
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

  /// Applies a bouncing effect.
  const factory EasyDialogAnimation.bounce({Curve curve}) = _Bounce<D>;

  /// Softly applies blur animation.
  const factory EasyDialogAnimation.blurBackground({
    Color backgroundColor,
    Curve curve,
    double amount,
  }) = _BlurBackground<D>;

  /// Applies fade type animation with a specific amount of [blur].
  const factory EasyDialogAnimation.fadeBackground({
    Color backgroundColor,
    double blur,
    Curve curve,
  }) = _FadeBackground<D>;
}

final class _Fade<D extends EasyDialog> extends EasyDialogAnimation<D> {
  const _Fade({super.curve = _defaultCurve});

  @override
  Widget call(D dialog) {
    final animation = dialog.context.animation;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: curve,
      ),
      child: dialog.content,
    );
  }
}

final class _Expansion<D extends EasyDialog> extends EasyDialogAnimation<D> {
  const _Expansion({super.curve = _defaultCurve});

  @override
  Widget call(D dialog) {
    final animation = dialog.context.animation;
    final tween = Tween<double>(begin: 0.0, end: 1.0);
    final heightFactor = animation.drive(
      tween.chain(
        CurveTween(curve: curve),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) => ClipRect(
        child: Align(
          heightFactor: heightFactor.value,
          child: child!,
        ),
      ),
      child: dialog.content,
    );
  }
}

final class _BlurBackground<D extends EasyDialog>
    extends EasyDialogAnimation<D> {
  final Color backgroundColor;
  final double amount;

  const _BlurBackground({
    this.backgroundColor = _defaultBackgroundColor,
    this.amount = 8.0,
    super.curve = _defaultBlurCurve,
  });

  @override
  Widget call(EasyDialog dialog) {
    final animation = dialog.context.animation;
    final fadeTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    );
    const fadeInterval = Interval(
      0.0,
      0.35,
      curve: Curves.easeInOut,
    );
    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: fadeInterval,
    ).drive(fadeTween);

    final blurTween = Tween<double>(begin: 0.0, end: amount);

    final blurTweenSequence = TweenSequence([
      TweenSequenceItem(tween: blurTween, weight: 0.8),
      TweenSequenceItem(tween: ConstantTween(amount), weight: 0.35),
    ]);

    return SizedBox(
      height: double.infinity,
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, child) => EasyFullScreenBlur(
          blur: animation
              .drive(
                blurTweenSequence.chain(
                  CurveTween(curve: curve),
                ),
              )
              .value,
          opacity: fadeAnimation.value,
          backgroundColor: backgroundColor,
          child: child!,
        ),
        child: dialog.content,
      ),
    );
  }
}

final class _FadeBackground<D extends EasyDialog>
    extends EasyDialogAnimation<D> {
  final double blur;
  final Color backgroundColor;

  const _FadeBackground({
    this.backgroundColor = _defaultBackgroundColor,
    this.blur = _defaultBlur,
    super.curve = Curves.easeInOut,
  });

  @override
  Widget call(D dialog) {
    final animation = dialog.context.animation;

    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, child) => EasyFullScreenBlur(
          blur: blur,
          opacity: CurvedAnimation(
            parent: animation,
            curve: super.curve,
          ).value,
          backgroundColor: backgroundColor,
          child: child!,
        ),
        child: dialog.content,
      ),
    );
  }
}

const _defaultBounceCurve = Curves.linear;

final class _Bounce<D extends EasyDialog> extends EasyDialogAnimation<D> {
  const _Bounce({super.curve = _defaultBounceCurve});

  @override
  Widget call(D dialog) {
    final animation = dialog.context.animation;
    final scaleUpChildTween = Tween<double>(
      begin: 0.1,
      end: 1.2,
    );

    final scaleDownChildTween = Tween<double>(
      begin: 1.2,
      end: 1.0,
    );
    final scaleTweenSequence = TweenSequence([
      TweenSequenceItem(tween: scaleUpChildTween, weight: 0.75),
      TweenSequenceItem(tween: scaleDownChildTween, weight: 0.4),
    ]);

    final fadeTweenSequence = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ),
        weight: 0.8,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 0.55),
    ]);

    return FadeTransition(
      opacity: animation.drive(
        fadeTweenSequence.chain(
          CurveTween(curve: curve),
        ),
      ),
      child: ScaleTransition(
        scale: animation.drive(
          scaleTweenSequence.chain(
            CurveTween(curve: curve),
          ),
        ),
        child: dialog.content,
      ),
    );
  }
}

extension EasyDialogAnimationX<D extends EasyDialog> on EasyDialogAnimation<D> {
  EasyDialogAnimation<D> interval(double begin, double end) =>
      _AnimationDecorator<D>(
        target: this,
        contextBuilder: (dialog) => _IntervalAnimationContext(
          target: dialog.context,
          interval: Interval(
            begin,
            end,
          ),
        ),
      );

  EasyDialogAnimation<D> reversed() => _AnimationDecorator<D>(
        target: this,
        contextBuilder: (dialog) => _ReversedAnimationContext(
          target: dialog.context,
        ),
      );

  EasyDialogAnimation<D> tweenSequence(TweenSequence<double> sequence) =>
      _AnimationDecorator<D>(
        target: this,
        contextBuilder: (dialog) => _DrivenAnimationContext(
          target: dialog.context,
          animatable: sequence.chain(
            CurveTween(curve: curve),
          ),
        ),
      );
}

final class _AnimationDecorator<D extends EasyDialog>
    extends EasyDialogAnimation<D> {
  final EasyDialogAnimation<D> target;
  final EasyDialogContext Function(D dialog) contextBuilder;

  const _AnimationDecorator({
    required this.target,
    required this.contextBuilder,
  });

  @override
  Widget call(D dialog) {
    return target(
      (dialog.clone().._context = contextBuilder(dialog)) as D,
    );
  }
}

final class _IntervalAnimationContext extends _EasyDialogContextDecorator {
  final Interval interval;

  _IntervalAnimationContext({
    required super.target,
    required this.interval,
  });

  @override
  Animation<double> get animation =>
      CurvedAnimation(parent: super.animation, curve: interval);
}

final class _ReversedAnimationContext extends _EasyDialogContextDecorator {
  _ReversedAnimationContext({required super.target});

  @override
  Animation<double> get animation => ReverseAnimation(super.animation);
}

final class _DrivenAnimationContext extends _EasyDialogContextDecorator {
  final Animatable<double> animatable;

  _DrivenAnimationContext({
    required super.target,
    required this.animatable,
  });

  @override
  Animation<double> get animation => super.animation.drive(animatable);
}
