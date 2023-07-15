part of 'full_screen_background_animation.dart';

const _defaultBackgroundColor = Color.fromARGB(44, 117, 116, 116);
const _defaultBlurCurve = Curves.easeInOut;

final class _Blur extends FullScreenBackgroundAnimation {
  final Color backgroundColor;
  final double start;
  final double end;

  const _Blur({
    this.backgroundColor = _defaultBackgroundColor,
    this.start = 0.0,
    this.end = 8.0,
    super.curve = _defaultBlurCurve,
  });

  @override
  Widget call(FullScreenDialog dialog) {
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

    final blurTween = Tween<double>(begin: start, end: end);

    final blurTweenSequence = TweenSequence([
      TweenSequenceItem(tween: blurTween, weight: 0.8),
      TweenSequenceItem(tween: ConstantTween(end), weight: 0.35),
    ]);

    return AnimatedBuilder(
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
    );
  }
}
