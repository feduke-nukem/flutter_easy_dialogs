part of 'full_screen_foreground_animation.dart';

final class _Fade extends FullScreenForegroundAnimation {
  const _Fade({super.curve = Curves.easeInOutCubic});

  @override
  Widget call(FullScreenDialog dialog) {
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
