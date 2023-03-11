import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/animations.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';

/// Class-converter for getting matching animation instance
class PositionToAnimationConverter {
  IEasyAnimator convert({
    required Curve? curve,
    required EasyDialogPosition position,
    required IPositionToAnimationConvertStrategy strategy,
  }) {
    final animation = strategy(
      curve: curve,
      position: position,
    );

    return animation;
  }
}

/// Interface of converting strategy
abstract class IPositionToAnimationConvertStrategy {
  IEasyAnimator call({
    required Curve? curve,
    required EasyDialogPosition position,
  });
}
