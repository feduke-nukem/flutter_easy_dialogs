import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/deprecated/easy_fullscreen_content_animation_type.dart';
import 'package:flutter_easy_dialogs/src/util/multiply_animation.dart';

part 'bounce.dart';
part 'expansion.dart';
part 'fade.dart';
part 'none.dart';

abstract class EasyFullScreenForegroundAnimator extends EasyDialogAnimator {
  const EasyFullScreenForegroundAnimator({
    super.curve,
  });

  @override
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  });

  const factory EasyFullScreenForegroundAnimator.bounce() = Bounce;

  const factory EasyFullScreenForegroundAnimator.fade({
    Curve? curve,
  }) = _Fade;

  const factory EasyFullScreenForegroundAnimator.expansion({Curve? curve}) =
      _Expansion;

  const factory EasyFullScreenForegroundAnimator.none() = _None;

  /// Should be removed after removing deprecated API.
  factory EasyFullScreenForegroundAnimator.fromType({
    required EasyFullScreenContentAnimationType type,
    Curve? curve,
  }) {
    switch (type) {
      case EasyFullScreenContentAnimationType.bounce:
        return EasyFullScreenForegroundAnimator.bounce();
      case EasyFullScreenContentAnimationType.expansion:
        return EasyFullScreenForegroundAnimator.expansion(curve: curve);
      case EasyFullScreenContentAnimationType.fade:
        return EasyFullScreenForegroundAnimator.fade(curve: curve);
      case EasyFullScreenContentAnimationType.none:
        return EasyFullScreenForegroundAnimator.none();
    }
  }
}
