import 'package:flutter/material.dart';

/// Base class of animation for EasyDialog
abstract class EasyAnimation implements IEasyAnimator {
  final Curve? curve;

  const EasyAnimation({
    this.curve,
  });
}

/// Interface of class - Animator for EasyDialogs
/// It's main purpose is to animate provided [Widget] child
abstract class IEasyAnimator {
  /// Animate widget [child]
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  });
}
