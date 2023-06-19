part of 'full_screen_background_animator.dart';

final class _None extends FullScreenBackgroundAnimator {
  const _None();

  @override
  Widget call(EasyDialog dialog) => dialog.child;
}
