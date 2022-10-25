import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/agents/compose_interfaces.dart';
import 'package:flutter_easy_dialogs/src/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_position.dart';

import '../../animations/easy_dialogs_animation_type.dart';

class BannerShowParams extends ShowParams
    implements IPositionable, IAnimatable, IAutoHidable {
  BannerShowParams({
    required this.animationType,
    required this.position,
    required this.autoHide,
    required super.content,
    required super.theme,
    this.padding,
    this.durationUntilHide,
    super.animationSettings,
  });

  final EdgeInsets? padding;

  @override
  final EasyDialogsAnimationType animationType;

  @override
  final EasyDialogPosition position;

  @override
  final bool autoHide;

  @override
  final Duration? durationUntilHide;
}
