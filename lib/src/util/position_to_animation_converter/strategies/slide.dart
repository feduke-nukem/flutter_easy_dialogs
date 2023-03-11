import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/animations.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/dialogs.dart';
import 'package:flutter_easy_dialogs/src/util/position_to_animation_converter/position_to_animation_converter.dart';

/// Slide convert strategy
class SlideAnimationConverterStrategy
    implements IPositionToAnimationConvertStrategy {
  @override
  IEasyAnimator call({
    required Curve? curve,
    required EasyDialogPosition position,
  }) {
    return EasyVerticalSlideAnimation(position: position, curve: curve);
  }

  /// Creates an instance of [SlideAnimationConverterStrategy]
  const SlideAnimationConverterStrategy();
}
