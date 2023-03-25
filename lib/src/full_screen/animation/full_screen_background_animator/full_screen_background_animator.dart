import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';
part 'blur.dart';
part 'fade.dart';
part 'none.dart';

/// This is an implementation of [EasyDialogAnimator] that is specific to
/// [FullScreenDialogManager].
///
/// It is responsible for applying an animation to the background
/// of the provided dialog content using [curve].
///
/// See also:
///
/// * [FullScreenForegroundAnimator].
/// * [PositionedAnimator].
abstract class FullScreenBackgroundAnimator extends EasyDialogAnimator {
  /// @nodoc
  const FullScreenBackgroundAnimator({super.curve});

  /// Softly applies blur animation.
  const factory FullScreenBackgroundAnimator.blur({
    Color backgroundColor,
    Curve? curve,
  }) = _Blur;

  /// Applies fade type animation with a specific amount of [blur].
  const factory FullScreenBackgroundAnimator.fade({
    Color backgroundColor,
    double blur,
    Curve? curve,
  }) = _Fade;

  /// No animation will be applied.
  const factory FullScreenBackgroundAnimator.none() = _None;
}
