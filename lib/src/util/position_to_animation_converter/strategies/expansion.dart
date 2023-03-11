import 'package:flutter/animation.dart';
import 'package:flutter_easy_dialogs/src/core/animations/animations.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/dialogs.dart';
import 'package:flutter_easy_dialogs/src/util/position_to_animation_converter/position_to_animation_converter.dart';

/// Expansion convert strategy
class ExpansionAnimationConverterStrategy
    implements IPositionToAnimationConvertStrategy {
  @override
  IEasyAnimator call({
    required Curve? curve,
    required EasyDialogPosition position,
  }) {
    return EasyExpansionAnimation(position: position, curve: curve);
  }

  /// Creates an instance of [ExpansionAnimationConverterStrategy]
  const ExpansionAnimationConverterStrategy();
}
