import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_position.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs_exception.dart';

import '../animations/animations.dart';

/// Class-converter for getting mathching animation instance
abstract class IPositionToAnimationConverter {
  EasyDialogsAnimation convert({
    required Curve curve,
    required EasyDialogsAnimationType animationType,
    required EasyDialogPosition position,
  });
}

class PositionToAnimationConverter implements IPositionToAnimationConverter {
  @override
  EasyDialogsAnimation convert({
    required Curve curve,
    required EasyDialogsAnimationType animationType,
    required EasyDialogPosition position,
  }) {
    switch (animationType) {
      case EasyDialogsAnimationType.slide:
        return _convertToSlideAnimation(
          curve: curve,
          position: position,
        );
      case EasyDialogsAnimationType.fade:
        return _convertToFadeAnimation(
          curve: curve,
          position: position,
        );
      default:
        Error.throwWithStackTrace(
          FlutterEasyDialogsError(message: 'no case for $animationType'),
          StackTrace.current,
        );
    }
  }

  EasyDialogsAnimation _convertToSlideAnimation({
    required EasyDialogPosition position,
    required Curve? curve,
  }) {
    switch (position) {
      case EasyDialogPosition.top:
        return EasyDialogsSlideFromTopAnimation(curve: curve);
      case EasyDialogPosition.bottom:
        return EasyDialogsSlideFromBotAnimation(curve: curve);
      default:
        Error.throwWithStackTrace(
          FlutterEasyDialogsError(message: 'no case for $position'),
          StackTrace.current,
        );
    }
  }

  EasyDialogsAnimation _convertToFadeAnimation({
    required EasyDialogPosition position,
    required Curve? curve,
  }) {
    return EasyDialogsFadeAnimation(
      position: position,
      curve: curve,
    );
  }
}
