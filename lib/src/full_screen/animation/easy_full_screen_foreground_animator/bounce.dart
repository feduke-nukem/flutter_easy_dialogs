part of 'easy_full_screen_foreground_animator.dart';

class Bounce extends EasyFullScreenForegroundAnimator {
  const Bounce();

  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    final scaleUpChildTween = Tween<double>(
      begin: 0.3,
      end: 1.5,
    );

    final scaleDownChildTween = Tween<double>(
      begin: 1.0,
      end: 1.0 / 1.5,
    );
    const scaleUpChildInterval = Interval(
      0.0,
      0.5,
      curve: Curves.bounceIn,
    );
    const scaleDownChildInterval = Interval(
      0.5,
      1,
      curve: Curves.bounceOut,
    );
    const fadeInterval = Interval(
      0.0,
      0.25,
      curve: Curves.easeInOut,
    );
    final fadeAnimation = CurvedAnimation(
      parent: parent,
      curve: fadeInterval,
    ).drive(
      Tween<double>(
        begin: 0.3,
        end: 1.0,
      ),
    );

    final scaleUpAnimation = CurvedAnimation(
      parent: parent,
      curve: scaleUpChildInterval,
    ).drive(scaleUpChildTween);

    final scaleDownAnimation = CurvedAnimation(
      parent: parent,
      curve: scaleDownChildInterval,
    ).drive(scaleDownChildTween);

    final scaleAnimation = MultiplyAnimation(
      first: scaleUpAnimation,
      next: scaleDownAnimation,
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }
}
