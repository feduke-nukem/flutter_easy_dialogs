import 'package:flutter_easy_dialogs/src/core/animations/easy_animation.dart';
import 'package:flutter_easy_dialogs/src/core/animations/factory/easy_animation_factory.dart';
import 'package:flutter_easy_dialogs/src/core/animations/factory/positioned_animation_factory/positioned_animation_create_params.dart';
import 'package:flutter_easy_dialogs/src/core/animations/types/easy_positioned_animation_type.dart';
import 'package:flutter_easy_dialogs/src/utils/position_to_animation_converter/approaches/approaches.dart';
import 'package:flutter_easy_dialogs/src/utils/position_to_animation_converter/position_to_animation_converter.dart';

class PositionedAnimationFactory implements IEasyAnimationFactory {
  final PositionToAnimationConverter _positionToAnimationConverter;

  PositionedAnimationFactory(this._positionToAnimationConverter);

  @override
  IEasyAnimator createAnimation({
    required PositionedAnimationCreateParams params,
  }) {
    switch (params.animationType) {
      case EasyPositionedAnimationType.slide:
        return _positionToAnimationConverter.convert(
          curve: params.curve,
          position: params.position,
          approach: const SlideAnimationConverterApproach(),
        );
      case EasyPositionedAnimationType.fade:
        return _positionToAnimationConverter.convert(
          curve: params.curve,
          position: params.position,
          approach: const FadeAnimationConverterApproach(),
        );
      case EasyPositionedAnimationType.expansion:
        return _positionToAnimationConverter.convert(
          curve: params.curve,
          position: params.position,
          approach: const ExpansionAnimationConverterApproach(),
        );
      default:
        Error.throwWithStackTrace(
          'no case for ${params.animationType}',
          StackTrace.current,
        );
    }
  }
}
