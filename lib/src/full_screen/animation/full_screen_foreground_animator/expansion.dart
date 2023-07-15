part of 'full_screen_foreground_animation.dart';

final class _Expansion extends FullScreenForegroundAnimation {
  const _Expansion({super.curve = Curves.easeInOutCubic});

  @override
  Widget call(FullScreenDialog dialog) {
    final animation = dialog.context.animation;
    final tween = Tween<double>(begin: 0.0, end: 1.0);
    final heightFactor = animation.drive(
      tween.chain(
        CurveTween(curve: curve),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) => Center(
        child: ClipRect(
          child: Align(
            heightFactor: heightFactor.value,
            child: child!,
          ),
        ),
      ),
      child: dialog.content,
    );
  }
}
