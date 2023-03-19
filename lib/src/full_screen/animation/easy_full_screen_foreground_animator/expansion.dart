part of 'easy_full_screen_foreground_animator.dart';

class _Expansion extends EasyFullScreenForegroundAnimator {
  const _Expansion({super.curve});

  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    final tween = Tween<double>(begin: 0.0, end: 1.0);
    final heightFactor = curve != null
        ? parent.drive(
            tween.chain(
              CurveTween(curve: curve!),
            ),
          )
        : parent.drive(
            tween.chain(
              CurveTween(
                curve: Curves.easeInCubic,
              ),
            ),
          );

    return AnimatedBuilder(
      animation: parent,
      builder: (_, child) => Center(
        child: ClipRect(
          child: Align(
            heightFactor: heightFactor.value,
            child: child!,
          ),
        ),
      ),
      child: child,
    );
  }
}
