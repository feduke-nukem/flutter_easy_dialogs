part of 'easy_full_screen_background_animator.dart';

class _None extends EasyFullScreenBackgroundAnimator {
  const _None();

  @override
  Widget animate({required Animation<double> parent, required Widget child}) =>
      child;
}
