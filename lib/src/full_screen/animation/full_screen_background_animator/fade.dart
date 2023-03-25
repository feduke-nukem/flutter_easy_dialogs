part of 'full_screen_background_animator.dart';

const _defaultBlur = 0.5;

class _Fade extends FullScreenBackgroundAnimator {
  final double blur;
  final Color backgroundColor;

  const _Fade({
    this.backgroundColor = _defaultBackgroundColor,
    this.blur = _defaultBlur,
    super.curve,
  });

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    return AnimatedBuilder(
      animation: data.parent,
      builder: (_, child) => EasyFullScreenBlur(
        blur: _defaultBlur,
        opacity: CurvedAnimation(
          parent: data.parent,
          curve: super.curve ?? Curves.easeInOut,
        ).value,
        backgroundColor: backgroundColor,
        child: child!,
      ),
      child: data.dialog,
    );
  }
}
