part of 'full_screen_foreground_animation.dart';

const _defaultBounceCurve = Curves.linear;

final class Bounce extends FullScreenForegroundAnimation {
  const Bounce({super.curve = _defaultBounceCurve});

  @override
  Widget call(FullScreenDialog dialog, Widget content) {
    final animation = dialog.context.animation;
    final scaleUpChildTween = Tween<double>(
      begin: 0.1,
      end: 1.2,
    );

    final scaleDownChildTween = Tween<double>(
      begin: 1.2,
      end: 1.0,
    );
    final scaleTweenSequence = TweenSequence([
      TweenSequenceItem(tween: scaleUpChildTween, weight: 0.75),
      TweenSequenceItem(tween: scaleDownChildTween, weight: 0.4),
    ]);

    final fadeTweenSequence = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ),
        weight: 0.8,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 0.55),
    ]);

    return FadeTransition(
      opacity: animation.drive(
        fadeTweenSequence.chain(
          CurveTween(curve: curve),
        ),
      ),
      child: ScaleTransition(
        scale: animation.drive(
          scaleTweenSequence.chain(
            CurveTween(curve: curve),
          ),
        ),
        child: content,
      ),
    );
  }
}
