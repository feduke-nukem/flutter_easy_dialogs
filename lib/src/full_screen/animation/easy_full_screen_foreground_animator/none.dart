part of 'easy_full_screen_foreground_animator.dart';

class _None extends EasyFullScreenForegroundAnimator {
  const _None();

  @override
  Widget animate({required Animation<double> parent, required Widget child}) =>
      child;
}
