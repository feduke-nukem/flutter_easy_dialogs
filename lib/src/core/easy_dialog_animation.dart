part of 'easy_dialogs_controller.dart';

/// {@category Decorations}
/// {@category Migration guide from 2.x to 3.x}
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
  static const defaultCurve = Curves.linear;

  /// Desired curve to be applied to the animation.
  final Curve curve;

  /// @nodoc
  const EasyDialogAnimation({this.curve = defaultCurve});

  /// {@template easy_dialog_animation.fade}
  /// Simple fade transition.
  /// {@endtemplate}
  const factory EasyDialogAnimation.fade({Curve curve}) = _Fade<D>;

  /// {@template easy_dialog_animation.expansion}
  /// Expansion from inside to outside.
  /// {@endtemplate}
  const factory EasyDialogAnimation.expansion({Curve curve}) = _Expansion<D>;

  /// {@template easy_dialog_animation.bounce}
  /// Applies a bouncing effect.
  /// {@endtemplate}
  const factory EasyDialogAnimation.bounce({Curve curve}) = _Bounce<D>;

  /// {@template easy_dialog_animation.slideHorizontal}
  /// Applies a horizontal slide animation.
  /// {@endtemplate}
  const factory EasyDialogAnimation.slideHorizontal({
    Curve curve,
    HorizontalSlideDirection direction,
  }) = _SlideHorizontal<D>;

  /// {@template easy_dialog_animation.slideVertical}
  /// Applies a vertical slide animation.
  /// {@endtemplate}
  const factory EasyDialogAnimation.slideVertical({
    Curve curve,
    VerticalSlideDirection direction,
  }) = _SlideVertical<D>;

  /// {@template easy_dialog_animation.blurBackground}
  /// Softly applies blur animation.
  /// {@endtemplate}
  const factory EasyDialogAnimation.blurBackground({
    Color backgroundColor,
    Curve curve,
    double amount,
  }) = _BlurBackground<D>;

  /// {@template easy_dialog_animation.fadeBackground}
  /// Applies fade type animation with a specific amount of [blur].
  /// {@endtemplate}
  const factory EasyDialogAnimation.fadeBackground({
    Color backgroundColor,
    double blur,
    Curve curve,
  }) = _FadeBackground<D>;
}

final class _Fade<D extends EasyDialog> extends EasyDialogAnimation<D> {
  const _Fade({super.curve = EasyDialogAnimation.defaultCurve});

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
  const _Expansion({super.curve = EasyDialogAnimation.defaultCurve});

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
  static const _defaultAmount = 8.0;
  static const _defaultBackgroundColor = Color.fromARGB(44, 117, 116, 116);

  final Color backgroundColor;
  final double amount;

  const _BlurBackground({
    this.backgroundColor = _defaultBackgroundColor,
    this.amount = _defaultAmount,
    super.curve = EasyDialogAnimation.defaultCurve,
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
        child: dialog is PositionedDialog
            ? Align(
                alignment: dialog.position.alignment,
                child: dialog.content,
              )
            : dialog.content,
      ),
    );
  }
}

final class _FadeBackground<D extends EasyDialog>
    extends EasyDialogAnimation<D> {
  static const _defaultBlur = 0.5;
  static const _defaultBackgroundColor = Color.fromARGB(44, 117, 116, 116);

  final double blur;
  final Color backgroundColor;

  const _FadeBackground({
    this.backgroundColor = _defaultBackgroundColor,
    this.blur = _defaultBlur,
    super.curve = EasyDialogAnimation.defaultCurve,
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
        child: dialog is PositionedDialog
            ? Align(
                alignment: dialog.position.alignment,
                child: dialog.content,
              )
            : dialog.content,
      ),
    );
  }
}

final class _Bounce<D extends EasyDialog> extends EasyDialogAnimation<D> {
  const _Bounce({super.curve = EasyDialogAnimation.defaultCurve});

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

enum HorizontalSlideDirection {
  rightToLeft,
  leftToRight,
}

final class _SlideHorizontal<D extends EasyDialog>
    extends EasyDialogAnimation<D> {
  static const _defaultDirection = HorizontalSlideDirection.leftToRight;

  final HorizontalSlideDirection direction;

  const _SlideHorizontal({
    this.direction = _defaultDirection,
    super.curve = EasyDialogAnimation.defaultCurve,
  });

  @override
  Widget call(D dialog) {
    final animation = dialog.context.animation;
    final tween = Tween<Offset>(
      begin: Offset(
        direction == HorizontalSlideDirection.rightToLeft ? 1.0 : -1.0,
        0.0,
      ),
      end: Offset.zero,
    );

    return SlideTransition(
      position: CurvedAnimation(
        parent: animation,
        curve: curve,
      ).drive(tween),
      child: dialog.content,
    );
  }
}

enum VerticalSlideDirection {
  up,
  down,
}

final class _SlideVertical<D extends EasyDialog>
    extends EasyDialogAnimation<D> {
  static const _defaultDirection = VerticalSlideDirection.up;

  final VerticalSlideDirection direction;

  const _SlideVertical({
    super.curve = EasyDialogAnimation.defaultCurve,
    this.direction = _defaultDirection,
  });

  @override
  Widget call(D dialog) {
    final tween = Tween<Offset>(
      begin: direction == VerticalSlideDirection.down
          ? const Offset(0.0, -1.0)
          : const Offset(0.0, 1.0),
      end: Offset.zero,
    );
    final offset = dialog.context.animation.drive(
      tween.chain(
        CurveTween(curve: curve),
      ),
    );

    return SlideTransition(
      position: offset,
      child: dialog.content,
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
      (dialog._copyWith(context: contextBuilder(dialog))) as D,
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
