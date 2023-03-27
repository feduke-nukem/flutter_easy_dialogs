import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:full_screen_dialog_manager/src/animation/full_screen_background_animator/full_screen_background_animator.dart';
import 'package:full_screen_dialog_manager/src/manager/full_screen_dialog_manager.dart';

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
abstract class FullScreenForegroundAnimator extends EasyDialogAnimator {
  /// @nodoc
  const FullScreenForegroundAnimator({super.curve});

  /// Applies a bouncing effect.
  const factory FullScreenForegroundAnimator.bounce() = Bounce;

  /// Simple fade transition.
  const factory FullScreenForegroundAnimator.fade({Curve curve}) = _Fade;

  /// Applies expansion from the inside to the outside.
  const factory FullScreenForegroundAnimator.expansion({Curve curve}) =
      _Expansion;

  /// No animation will be applied.
  const factory FullScreenForegroundAnimator.none() = _None;
}
