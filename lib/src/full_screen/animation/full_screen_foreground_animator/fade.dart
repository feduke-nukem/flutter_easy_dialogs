part of 'full_screen_foreground_animation.dart';

final class _Fade extends FullScreenForegroundAnimation {
  const _Fade({super.curve = Curves.easeInOutCubic});

  @override
  Widget call(
    EasyDialogContext<FullScreenDialog> context,
  ) {
    final animation = context.animation;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: curve,
      ),
      child: context.content,
    );
  }
}
