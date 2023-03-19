import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_animator.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_expansion_transition.dart';
import 'package:flutter_easy_dialogs/src/positioned/deprecated/easy_positioned_animation_type.dart';
import 'package:flutter_easy_dialogs/src/positioned/easy_dialog_position.dart';

part 'fade.dart';
part 'expansion.dart';
part 'slide.dart';

const _defaultCurve = Curves.fastLinearToSlowEaseIn;

/// Union class of positioned animations.
abstract class EasyPositionedAnimator extends EasyAnimator {
  const EasyPositionedAnimator({
    super.curve,
  });

  @override
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  });

  const factory EasyPositionedAnimator.slide({
    Curve? curve,
  }) = _Slide;

  const factory EasyPositionedAnimator.expansion({
    Curve? curve,
  }) = _Expansion;

  const factory EasyPositionedAnimator.fade({
    Curve? curve,
  }) = _Fade;

  /// Should be removed after removing deprecated API.
  factory EasyPositionedAnimator.fromType({
    required EasyPositionedAnimationType type,
    Curve? curve,
  }) {
    switch (type) {
      case EasyPositionedAnimationType.slide:
        return EasyPositionedAnimator.slide(curve: curve);
      case EasyPositionedAnimationType.fade:
        return EasyPositionedAnimator.fade(curve: curve);
      case EasyPositionedAnimationType.expansion:
        return EasyPositionedAnimator.expansion(curve: curve);
    }
  }
}
