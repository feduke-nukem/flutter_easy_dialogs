import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation.dart';

/// Interface for animation factory
abstract class IEasyAnimationFactory {
  /// Core method for creating an animation
  IEasyAnimator createAnimation({
    required covariant CreateAnimationParams params,
  });
}

/// Core dto class for providing params to [IEasyAnimationFactory]'s
/// createAnimation method
abstract class CreateAnimationParams {
  final Curve curve;

  const CreateAnimationParams({
    required this.curve,
  });
}
