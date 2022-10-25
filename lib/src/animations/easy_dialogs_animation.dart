import 'package:flutter/material.dart';

/// Base class of animation for EasyDialog
abstract class EasyDialogsAnimation implements IEasyDialogsAnimator {
  final Curve? curve;

  const EasyDialogsAnimation({
    this.curve,
  });
}

/// Interface of class - Animator for EasyDialogs
/// It's main purpose is to animate provided [Widget] child
abstract class IEasyDialogsAnimator {
  /// Animate widget [child]
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  });
}
