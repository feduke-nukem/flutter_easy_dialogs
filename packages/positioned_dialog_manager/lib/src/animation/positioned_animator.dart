import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';
import 'package:positioned_dialog_manager/src/manager/positioned_dialog_manager.dart';

part 'fade.dart';
part 'expansion.dart';
part 'vertical_slide.dart';

const _defaultCurve = Curves.fastLinearToSlowEaseIn;

/// This is an implementation of [EasyDialogAnimator] that is specific to
/// [PositionedDialogManager].
///
/// It is responsible for applying an animation to the provided
/// dialog content using [curve].
abstract class PositionedAnimator
    extends EasyDialogAnimator<PositionedAnimatorData> {
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

/// Specific to [PositionedAnimator] data.
class PositionedAnimatorData extends EasyDialogAnimatorData {
  /// Position of a provided [dialog].
  final EasyDialogPosition position;

  /// @nodoc
  const PositionedAnimatorData({
    required this.position,
    required super.parent,
    required super.dialog,
  });
}
