import 'package:flutter_easy_dialogs/src/core/agents/compose_interfaces.dart';
import 'package:flutter_easy_dialogs/src/core/animations/factory/easy_animation_factory.dart';
import 'package:flutter_easy_dialogs/src/core/animations/types/easy_positioned_animation_type.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';

class PositionedAnimationCreateParams extends CreateAnimationParams
    implements IPositionableSettings, IPositionedAnimatableSettings {
  @override
  final EasyPositionedAnimationType animationType;

  @override
  final EasyDialogPosition position;

  const PositionedAnimationCreateParams({
    required super.curve,
    required this.position,
    required this.animationType,
  });
}
