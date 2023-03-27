part of 'full_screen_background_animator.dart';

class _None extends FullScreenBackgroundAnimator {
  const _None();

  @override
  Widget decorate(EasyDialogAnimatorData data) => data.dialog;
}
