import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'bounce.dart';
part 'expansion.dart';
part 'fade.dart';

/// This is an implementation of [EasyDialogAnimation] that is specific to
/// [FullScreenDialog].
///
/// It is responsible for applying an animation to the foreground
/// of the provided dialog content using [curve].
///
/// See also:
///
/// * [FullScreenBackgroundAnimation].
abstract base class FullScreenForegroundAnimation
    extends EasyDialogAnimation<FullScreenDialog> {
  /// @nodoc
  const FullScreenForegroundAnimation({super.curve});

  /// Applies a bouncing effect.
  const factory FullScreenForegroundAnimation.bounce({Curve curve}) = _Bounce;

  /// Simple fade transition.
  const factory FullScreenForegroundAnimation.fade({Curve curve}) = _Fade;

  /// Applies expansion from the inside to the outside.
  const factory FullScreenForegroundAnimation.expansion({Curve curve}) =
      _Expansion;
}