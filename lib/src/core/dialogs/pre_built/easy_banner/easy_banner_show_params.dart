import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/agents/compose_interfaces.dart';
import 'package:flutter_easy_dialogs/src/core/agents/positioned_dialog_agent.dart/positioned_dialog_show_params.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation.dart';
import 'package:flutter_easy_dialogs/src/core/animations/types/easy_positioned_animation_type.dart';

class EasyBannerShowParams extends PositionedDialogShowParams
    implements IPositionedAnimatableSettings, IDissmisableSettings {
  final EdgeInsets? padding;

  @override
  final EasyPositionedAnimationType animationType;

  final IEasyAnimator? customAnimation;

  EasyBannerShowParams({
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
