part of 'easy_full_screen_background_animator.dart';

const _defaultBackgroundColor = Color.fromARGB(44, 117, 116, 116);

class _Blur extends EasyFullScreenBackgroundAnimator {
  final Color backgroundColor;

  const _Blur({
    this.backgroundColor = _defaultBackgroundColor,
    super.curve,
  });

  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
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
      parent: parent,
      curve: fadeInterval,
    ).drive(fadeTween);

    return AnimatedBuilder(
      animation: parent,
      builder: (_, child) => EasyFullScreenBlur(
        blur: (curve != null
                ? parent.drive(blurTween.chain(CurveTween(curve: curve!)))
                : blurTween.animate(parent))
            .value,
        opacity: fadeAnimation.value,
        backgroundColor: backgroundColor,
        child: child!,
      ),
      child: child,
    );
  }
}
