import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_position.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs_exception.dart';

import '../animations/animations.dart';

/// Class-converter for getting mathching animation instance
abstract class IPositionToAnimationConverter {
  EasyDialogsAnimation convert({
    required EasyDialogsAnimationSettings animationSettings,
    required EasyDialogsAnimationType animationType,
    required EasyDialogPosition position,
  });
}

class PositionToAnimationConverter implements IPositionToAnimationConverter {
  @override
  EasyDialogsAnimation convert({
    required EasyDialogsAnimationSettings animationSettings,
    required EasyDialogsAnimationType animationType,
    required EasyDialogPosition position,
  }) {
    switch (animationType) {
      case EasyDialogsAnimationType.slide:
        return _convertToSlideAnimation(
          settings: animationSettings,
          position: position,
        );
      case EasyDialogsAnimationType.fade:
        return _convertToFadeAnimation(
          data: animationSettings,
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
    required EasyDialogsAnimationSettings settings,
    required EasyDialogPosition position,
  }) {
    switch (position) {
      case EasyDialogPosition.top:
        return EasyDialogsSlideFromTopAnimation(settings: settings);
      case EasyDialogPosition.bottom:
        return EasyDialogsSlideFromBotAnimation(settings: settings);
      default:
        Error.throwWithStackTrace(
          FlutterEasyDialogsError(message: 'no case for $position'),
          StackTrace.current,
        );
    }
  }

  EasyDialogsAnimation _convertToFadeAnimation({
    required EasyDialogsAnimationSettings data,
    required EasyDialogPosition position,
  }) {
    return EasyDialogsFadeAnimation(settings: data, position: position);
  }
}
