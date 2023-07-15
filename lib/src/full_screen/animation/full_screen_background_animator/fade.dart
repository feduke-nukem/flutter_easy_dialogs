part of 'full_screen_background_animation.dart';

const _defaultBlur = 0.5;

final class _Fade extends FullScreenBackgroundAnimation {
  final double blur;
  final Color backgroundColor;

  const _Fade({
    this.backgroundColor = _defaultBackgroundColor,
    this.blur = _defaultBlur,
    super.curve = Curves.easeInOut,
  });

  @override
  Widget call(FullScreenDialog dialog) {
    final animation = dialog.context.animation;

    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) => EasyFullScreenBlur(
        blur: _defaultBlur,
        opacity: CurvedAnimation(
          parent: animation,
          curve: super.curve,
        ).value,
        backgroundColor: backgroundColor,
        child: child!,
      ),
      child: dialog.content,
    );
  }
}
