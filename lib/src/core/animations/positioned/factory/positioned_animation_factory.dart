import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/util/position_to_animation_converter/position_to_animation_converter.dart';
import 'package:flutter_easy_dialogs/src/util/position_to_animation_converter/strategies/expansion.dart';
import 'package:flutter_easy_dialogs/src/util/position_to_animation_converter/strategies/fade.dart';
import 'package:flutter_easy_dialogs/src/util/position_to_animation_converter/strategies/slide.dart';

/// Positioned animation factory
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
          strategy: const SlideAnimationConverterStrategy(),
        );
      case EasyPositionedAnimationType.fade:
        return _positionToAnimationConverter.convert(
          curve: params.curve,
          position: params.position,
          strategy: const FadeAnimationConverterStrategy(),
        );
      case EasyPositionedAnimationType.expansion:
        return _positionToAnimationConverter.convert(
          curve: params.curve,
          position: params.position,
          strategy: const ExpansionAnimationConverterStrategy(),
        );
      default:
        Error.throwWithStackTrace(
          'no case for ${params.animationType}',
          StackTrace.current,
        );
    }
  }
}

/// Positioned animation create params
class PositionedAnimationCreateParams extends CreateAnimationParams {
  /// Animation type
  final EasyPositionedAnimationType animationType;

  /// Position of a dialog
  final EasyDialogPosition position;

  /// Creates ain instance of [PositionedAnimationCreateParams]
  const PositionedAnimationCreateParams({
    required super.curve,
    required this.position,
    required this.animationType,
  });
}
