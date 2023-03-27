part of 'full_screen_foreground_animator.dart';

class _None extends FullScreenForegroundAnimator {
  const _None();

  @override
  Widget decorate(EasyDialogAnimatorData data) => data.dialog;
}
