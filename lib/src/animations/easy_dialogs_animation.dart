import 'package:flutter/material.dart';

/// Base class of animation for EasyDialog
abstract class EasyDialogsAnimation extends EasyDialogsAnimatableData
    implements IEasyDialogsAnimator {
  EasyDialogsAnimation({
    required super.curve,
    required super.duration,
    required super.reverseDuration,
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

/// Data class of animation information
abstract class EasyDialogsAnimatableData {
  /// Animation's duration
  final Duration duration;

  /// Animation's reverse duration
  final Duration reverseDuration;

  /// Animation's curve
  final Curve curve;

  const EasyDialogsAnimatableData({
    required this.curve,
    required this.duration,
    required this.reverseDuration,
  });
}
