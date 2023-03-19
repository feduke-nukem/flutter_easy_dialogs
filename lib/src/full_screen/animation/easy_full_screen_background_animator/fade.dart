part of 'easy_full_screen_background_animator.dart';

const _defaultBlur = 0.5;

class _Fade extends EasyFullScreenBackgroundAnimator {
  final double blur;
  final Color backgroundColor;

  const _Fade({
    this.backgroundColor = _defaultBackgroundColor,
    this.blur = _defaultBlur,
    super.curve,
  });

  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    return AnimatedBuilder(
      animation: parent,
      builder: (_, child) => EasyFullScreenBlur(
        blur: _defaultBlur,
        opacity: CurvedAnimation(
          parent: parent,
          curve: super.curve ?? Curves.easeInOut,
        ).value,
        backgroundColor: backgroundColor,
        child: child!,
      ),
      child: child,
    );
  }
}
