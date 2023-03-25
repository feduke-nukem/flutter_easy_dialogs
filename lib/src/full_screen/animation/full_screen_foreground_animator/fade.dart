part of 'full_screen_foreground_animator.dart';

class _Fade extends FullScreenForegroundAnimator {
  const _Fade({
    super.curve,
  });

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: data.parent,
        curve: curve ?? Curves.easeInOutCubic,
      ),
      child: data.dialog,
    );
  }
}
