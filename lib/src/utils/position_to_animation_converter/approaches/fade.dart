import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/animations.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/dialogs.dart';
import 'package:flutter_easy_dialogs/src/utils/position_to_animation_converter/position_to_animation_converter.dart';

/// Fade convert strategy
class FadeAnimationConverterApproach
    implements IPositionToAnimationConvertApproach {
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

  /// Creates an instance of [FadeAnimationConverterApproach]
  const FadeAnimationConverterApproach();
}
