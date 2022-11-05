import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/agents/positioned_dialog_agent.dart/positioned_dialog_show_params.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation.dart';
import 'package:flutter_easy_dialogs/src/core/animations/types/easy_positioned_animation_type.dart';

/// Show params for EasyBanner
class EasyBannerShowParams extends PositionedDialogShowParams {
  /// Padding
  final EdgeInsets? padding;

  /// Animation type
  final EasyPositionedAnimationType animationType;

  /// Custom animation
  final IEasyAnimator? customAnimation;

  /// Creates an instance of [EasyBannerShowParams]
  const EasyBannerShowParams({
    required this.animationType,
    required super.position,
    required super.autoHide,
    required super.dismissibleType,
    required super.content,
    required super.theme,
    this.padding,
    this.customAnimation,
    super.onDismissed,
    super.durationUntilHide,
    super.animationSettings,
  });
}
