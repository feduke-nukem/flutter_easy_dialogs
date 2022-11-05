import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/animations.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';

/// Class-converter for getting mathching animation instance
class PositionToAnimationConverter {
  IEasyAnimator convert({
    required Curve? curve,
    required EasyDialogPosition position,
    required IPositionToAnimationConvertApproach approach,
  }) {
    final animation = approach(
      curve: curve,
      position: position,
    );

    return animation;
  }
}

/// Interface of converting strategy
abstract class IPositionToAnimationConvertApproach {
  IEasyAnimator call({
    required Curve? curve,
    required EasyDialogPosition position,
  });
}
