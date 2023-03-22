import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/deprecated/easy_full_screen_background_animation_type.dart';
import 'package:flutter_easy_dialogs/src/full_screen/widgets/easy_full_screen_blur.dart';
part 'blur.dart';
part 'fade.dart';
part 'none.dart';

const _defaultOpacity = 0.5;

abstract class EasyFullScreenBackgroundAnimator extends EasyDialogAnimator {
  const EasyFullScreenBackgroundAnimator({
    super.curve,
  });

  @override
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  });

  const factory EasyFullScreenBackgroundAnimator.blur({
    Color backgroundColor,
    Curve? curve,
  }) = _Blur;

  const factory EasyFullScreenBackgroundAnimator.fade({
    Color backgroundColor,
    double blur,
    Curve? curve,
  }) = _Fade;

  const factory EasyFullScreenBackgroundAnimator.none() = _None;

  /// Should be removed after removing deprecated API.
  factory EasyFullScreenBackgroundAnimator.fromType({
    required EasyFullScreenBackgroundAnimationType type,
    Curve? curve,
    Color? backgroundColor,
  }) {
    switch (type) {
      case EasyFullScreenBackgroundAnimationType.blur:
        return EasyFullScreenBackgroundAnimator.blur(
          backgroundColor: backgroundColor ?? _defaultBackgroundColor,
          curve: curve,
        );
      case EasyFullScreenBackgroundAnimationType.fade:
        return EasyFullScreenBackgroundAnimator.fade(
          backgroundColor: backgroundColor ??
              Colors.grey.shade300.withOpacity(_defaultOpacity),
          blur: _defaultBlur,
          curve: curve,
        );
      case EasyFullScreenBackgroundAnimationType.none:
        return EasyFullScreenBackgroundAnimator.none();
    }
  }
}
