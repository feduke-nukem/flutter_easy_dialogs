import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'vertical_slide.dart';

const _defaultCurve = Curves.fastLinearToSlowEaseIn;

/// This is an implementation of [EasyDialogAnimation] that is specific to
/// [PositionedDialog].
///
/// It is responsible for applying an animation to the provided
/// dialog content using [curve].
abstract base class PositionedAnimation
    extends EasyDialogAnimation<PositionedDialog> {
  /// @nodoc
  const PositionedAnimation({super.curve});

  /// Applies vertical slide animation.
  const factory PositionedAnimation.verticalSlide({Curve curve}) =
      _VerticalSlide;
}
