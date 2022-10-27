import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/agents/compose_interfaces.dart';
import 'package:flutter_easy_dialogs/src/core/agents/positioned_dialog_agent.dart/positioned_dialog_show_params.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation_type.dart';

class BannerShowParams extends PositionedDialogShowParams
    implements IAnimatableSettings, IDissmisableSettings {
  final EdgeInsets? padding;

  @override
  final EasyAnimationType animationType;

  BannerShowParams({
    required this.animationType,
    required super.position,
    required super.autoHide,
    required super.dismissibleType,
    required super.content,
    required super.theme,
    this.padding,
    super.onDismissed,
    super.durationUntilHide,
    super.animationSettings,
  });
}
