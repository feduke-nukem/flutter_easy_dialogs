import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/full_screen_background_animator/full_screen_background_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/positioned/animation/positioned_animator.dart';
import 'package:flutter_easy_dialogs/src/util/multiply_animation.dart';

part 'bounce.dart';
part 'expansion.dart';
part 'fade.dart';
part 'none.dart';

/// This is an implementation of [EasyDialogAnimator] that is specific to
/// [FullScreenDialogManager].
///
/// It is responsible for applying an animation to the foreground
/// of the provided dialog content using [curve].
///
/// See also:
///
/// * [FullScreenBackgroundAnimator].
/// * [PositionedAnimator].
abstract class FullScreenForegroundAnimator extends EasyDialogAnimator {
  /// @nodoc
  const FullScreenForegroundAnimator({super.curve});

  /// Applies a bouncing effect.
  const factory FullScreenForegroundAnimator.bounce() = Bounce;

  /// Simple fade transition.
  const factory FullScreenForegroundAnimator.fade({Curve? curve}) = _Fade;

  /// Applies expansion from the inside to the outside.
  const factory FullScreenForegroundAnimator.expansion({Curve? curve}) =
      _Expansion;

  /// No animation will be applied.
  const factory FullScreenForegroundAnimator.none() = _None;
}
