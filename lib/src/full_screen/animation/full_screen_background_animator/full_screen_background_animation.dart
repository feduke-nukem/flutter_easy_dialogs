import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
part 'blur.dart';
part 'fade.dart';

/// This is an implementation of [EasyDialogAnimation] that is specific to
/// [FullScreenDialogConversation].
///
/// It is responsible for applying an animation to the background
/// of the provided dialog content using [curve].
///
/// See also:
///
/// * [FullScreenForegroundAnimation].
abstract base class FullScreenBackgroundAnimation
    extends EasyDialogAnimation<FullScreenDialog> {
  /// @nodoc
  const FullScreenBackgroundAnimation({super.curve});

  /// Softly applies blur animation.
  const factory FullScreenBackgroundAnimation.blur({
    Color backgroundColor,
    Curve curve,
    double start,
    double end,
  }) = _Blur;

  /// Applies fade type animation with a specific amount of [blur].
  const factory FullScreenBackgroundAnimation.fade({
    Color backgroundColor,
    double blur,
    Curve curve,
  }) = _Fade;
}
