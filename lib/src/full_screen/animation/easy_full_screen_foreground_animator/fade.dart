part of 'easy_full_screen_foreground_animator.dart';

class _Fade extends EasyFullScreenForegroundAnimator {
  const _Fade({
    super.curve,
  });

  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: parent,
        curve: curve ?? Curves.easeInOutCubic,
      ),
      child: child,
    );
  }
}
