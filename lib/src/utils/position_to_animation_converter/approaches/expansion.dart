import 'package:flutter/animation.dart';
import 'package:flutter_easy_dialogs/src/core/animations/animations.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/dialogs.dart';
import 'package:flutter_easy_dialogs/src/utils/position_to_animation_converter/position_to_animation_converter.dart';

class ExpansionAnimationConverterApproach
    implements IPositionToAnimationConvertApproach {
  @override
  IEasyAnimator call({
    required Curve? curve,
    required EasyDialogPosition position,
  }) {
    return EasyExpansionAnimation(position: position, curve: curve);
  }

  const ExpansionAnimationConverterApproach();
}
