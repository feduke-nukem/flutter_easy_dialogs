import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/animations.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/dialogs.dart';
import 'package:flutter_easy_dialogs/src/util/position_to_animation_converter/position_to_animation_converter.dart';

/// Fade convert strategy
class FadeAnimationConverterStrategy
    implements IPositionToAnimationConvertStrategy {
  @override
  EasyAnimation call({
    required Curve? curve,
    required EasyDialogPosition position,
  }) {
    return EasyFadeAnimation(
      position: position,
      curve: curve,
    );
  }

  /// Creates an instance of [FadeAnimationConverterStrategy]
  const FadeAnimationConverterStrategy();
}