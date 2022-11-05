import 'package:flutter/material.dart';

/// Base class of animation for EasyDialog
abstract class EasyAnimation implements IEasyAnimator {
  final Curve? curve;

  const EasyAnimation({
    this.curve,
  });
}

/// Interface of class - Animator for EasyDialogs
/// It's main purpose is to apply an animation to the provided [Widget] child
abstract class IEasyAnimator {
  /// Animate [child] using [parent] animation
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  });
}
