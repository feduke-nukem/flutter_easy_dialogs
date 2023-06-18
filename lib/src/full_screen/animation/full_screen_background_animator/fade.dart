part of 'full_screen_background_animator.dart';

const _defaultBlur = 0.5;

final class _Fade extends FullScreenBackgroundAnimator {
  const _Fade({
    this.backgroundColor = _defaultBackgroundColor,
    this.blur = _defaultBlur,
    super.curve = Curves.easeInOut,
  });

  final double blur;
  final Color backgroundColor;

  @override
  FullScreenDialog call(FullScreenDialog dialog) {
    final animation = dialog.animation;

    return dialog.copyWith(
      child: AnimatedBuilder(
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
        child: dialog.child,
      ),
    );
  }
}
