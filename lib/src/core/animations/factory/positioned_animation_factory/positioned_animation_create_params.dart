import 'package:flutter_easy_dialogs/src/core/animations/factory/i_easy_animation_factory.dart';
import 'package:flutter_easy_dialogs/src/core/animations/types/easy_positioned_animation_type.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';

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
