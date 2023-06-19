part of 'full_screen_foreground_animator.dart';

final class _Fade extends FullScreenForegroundAnimator {
  const _Fade({super.curve = Curves.easeInOutCubic});

  @override
  Widget call(FullScreenDialog dialog) {
    final animation = dialog.animation;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: curve,
      ),
      child: dialog.child,
    );
  }
}
