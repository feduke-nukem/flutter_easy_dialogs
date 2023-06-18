import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'fade.dart';
part 'expansion.dart';
part 'vertical_slide.dart';

const _defaultCurve = Curves.fastLinearToSlowEaseIn;

/// This is an implementation of [EasyDialogAnimator] that is specific to
/// [PositionedDialogConversation].
///
/// It is responsible for applying an animation to the provided
/// dialog content using [curve].
abstract base class PositionedAnimator extends EasyDialogAnimator {
  /// @nodoc
  const PositionedAnimator({super.curve});

  /// Applies vertical slide animation.
  const factory PositionedAnimator.verticalSlide({Curve curve}) =
      _VerticalSlide;

  /// Expansion from inside to outside.
  const factory PositionedAnimator.expansion({Curve curve}) = _Expansion;

  /// Simple fade transition.
  const factory PositionedAnimator.fade({Curve curve}) = _Fade;
}
