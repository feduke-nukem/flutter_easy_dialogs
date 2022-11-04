import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation.dart';

abstract class IEasyAnimationFactory {
  IEasyAnimator createAnimation({
    required covariant CreateAnimationParams params,
  });
}

abstract class CreateAnimationParams {
  final Curve curve;

  const CreateAnimationParams({
    required this.curve,
  });
}
