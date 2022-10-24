import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_position.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs_exception.dart';

import '../animations/animations.dart';

/// Class-converter for getting mathching animation instance
abstract class IPositionToAnimationConverter {
  EasyDialogsAnimation convert({
    required EasyDialogsAnimatableData data,
    required EasyDialogsAnimationType animationType,
    required EasyDialogsPosition position,
  });
}

class PositionToAnimationConverter implements IPositionToAnimationConverter {
  @override
  EasyDialogsAnimation convert({
    required EasyDialogsAnimatableData data,
    required EasyDialogsAnimationType animationType,
    required EasyDialogsPosition position,
  }) {
    switch (animationType) {
      case EasyDialogsAnimationType.slide:
        return _convertToSlideAnimation(
          data: data,
          position: position,
        );
      case EasyDialogsAnimationType.fade:
        return _convertToFadeAnimation(
          data: data,
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
    required EasyDialogsAnimatableData data,
    required EasyDialogsPosition position,
  }) {
    switch (position) {
      case EasyDialogsPosition.top:
        return EasyDialogsSlideFromTopAnimation(data: data);
      case EasyDialogsPosition.bottom:
        return EasyDialogsSlideFromBotAnimation(data: data);
      default:
        Error.throwWithStackTrace(
          FlutterEasyDialogsError(message: 'no case for $position'),
          StackTrace.current,
        );
    }
  }

  EasyDialogsAnimation _convertToFadeAnimation({
    required EasyDialogsAnimatableData data,
    required EasyDialogsPosition position,
  }) {
    return EasyDialogsFadeAnimation(data: data, position: position);
  }
}
