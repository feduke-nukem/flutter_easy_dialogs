part of 'full_screen_foreground_animator.dart';

final class _None extends FullScreenForegroundAnimator {
  const _None();

  @override
  EasyDialog call(EasyDialog dialog) => dialog;
}
