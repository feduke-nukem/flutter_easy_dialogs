import 'package:flutter/material.dart';

/// Base class of animation for EasyDialog.
abstract class EasyAnimator implements IEasyAnimator {
  final Curve? curve;

  const EasyAnimator({
    this.curve,
  });

  /// Combines provided [animators] sequentially.
  static EasyAnimator combine({
    required Iterable<EasyAnimator> animators,
  }) =>
      _MultipleEasyAnimator(animators: animators);
}

/// Interface of class - Animator for EasyDialogs.
///
/// It's main purpose is to apply an animation to the provided [Widget] child.
abstract class IEasyAnimator {
  /// Animate [child] using [parent] animation.
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  });
}

class _MultipleEasyAnimator extends EasyAnimator {
  final Iterable animators;

  const _MultipleEasyAnimator({
    required this.animators,
  }) : assert(animators.length > 0, 'animators should not be empty');

  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    Widget result = child;

    for (final animator in animators) {
      result = animator.animate(parent: parent, child: result);
    }

    return result;
  }
}
