part of 'full_screen_foreground_animator.dart';

class Bounce extends FullScreenForegroundAnimator {
  const Bounce();

  @override
  Widget decorate(EasyDialogAnimatorData data) {
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
      parent: data.parent,
      curve: fadeInterval,
    ).drive(
      Tween<double>(
        begin: 0.3,
        end: 1.0,
      ),
    );

    final scaleUpAnimation = CurvedAnimation(
      parent: data.parent,
      curve: scaleUpChildInterval,
    ).drive(scaleUpChildTween);

    final scaleDownAnimation = CurvedAnimation(
      parent: data.parent,
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
        child: data.dialog,
      ),
    );
  }
}
