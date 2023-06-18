part of 'full_screen_foreground_animator.dart';

final class _Fade extends FullScreenForegroundAnimator {
  const _Fade({super.curve = Curves.easeInOutCubic});

  @override
  FullScreenDialog call(FullScreenDialog dialog) {
    final animation = dialog.animation;

    return dialog.copyWith(
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
        child: dialog.child,
      ),
    );
  }
}
