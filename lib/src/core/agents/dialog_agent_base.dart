import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';

abstract class EasyDialogAgentBase {
  @protected
  @nonVirtual
  final IEasyDialogFactory dialogFactory;

  @protected
  @nonVirtual
  final IEasyOverlayController overlayController;

  const EasyDialogAgentBase({
    required this.overlayController,
    required this.dialogFactory,
  });

  Future<void> show({
    required covariant AgentShowParams params,
  });

  Future<void> hide({
    required covariant AgentHideParams? params,
  });
}

abstract class AgentShowParams {
  final Widget content;
  final FlutterEasyDialogsThemeData theme;
  final EasyAnimationSettings? animationSettings;

  const AgentShowParams({
    required this.theme,
    required this.content,
    this.animationSettings,
  });
}

abstract class AgentHideParams {
  const AgentHideParams();
}
