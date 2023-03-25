part of 'full_screen_foreground_animator.dart';

class _Expansion extends FullScreenForegroundAnimator {
  const _Expansion({super.curve});

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    final tween = Tween<double>(begin: 0.0, end: 1.0);
    final heightFactor = curve != null
        ? data.parent.drive(
            tween.chain(
              CurveTween(curve: curve!),
            ),
          )
        : data.parent.drive(
            tween.chain(
              CurveTween(
                curve: Curves.easeInCubic,
              ),
            ),
          );

    return AnimatedBuilder(
      animation: data.parent,
      builder: (_, child) => Center(
        child: ClipRect(
          child: Align(
            heightFactor: heightFactor.value,
            child: child!,
          ),
        ),
      ),
      child: data.dialog,
    );
  }
}
