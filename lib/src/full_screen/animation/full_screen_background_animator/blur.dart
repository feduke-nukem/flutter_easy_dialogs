part of 'full_screen_background_animator.dart';

const _defaultBackgroundColor = Color.fromARGB(44, 117, 116, 116);

class _Blur extends FullScreenBackgroundAnimator {
  final Color backgroundColor;

  const _Blur({
    this.backgroundColor = _defaultBackgroundColor,
    super.curve,
  });

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    final blurTween = Tween<double>(begin: 5.0, end: 8.0);
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
      parent: data.parent,
      curve: fadeInterval,
    ).drive(fadeTween);

    return AnimatedBuilder(
      animation: data.parent,
      builder: (_, child) => EasyFullScreenBlur(
        blur: (curve != null
                ? data.parent.drive(blurTween.chain(CurveTween(curve: curve!)))
                : blurTween.animate(data.parent))
            .value,
        opacity: fadeAnimation.value,
        backgroundColor: backgroundColor,
        child: child!,
      ),
      child: data.dialog,
    );
  }
}
