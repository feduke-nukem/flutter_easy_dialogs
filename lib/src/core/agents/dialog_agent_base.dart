import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation_settings.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs/easy_dialogs_theme.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';

abstract class EasyDialogAgentBase {
  @protected
  @nonVirtual
  final IEasyOverlayController overlayController;

  const EasyDialogAgentBase({
    required this.overlayController,
  });

  Future<void> show({
    required covariant ShowParams params,
  });

  Future<void> hide({
    required covariant HideParams params,
  });
}

abstract class ShowParams {
  final Widget content;
  final EasyDialogsThemeData theme;
  final EasyAnimationSettings? animationSettings;

  const ShowParams({
    required this.theme,
    required this.content,
    this.animationSettings,
  });
}

abstract class HideParams {
  const HideParams();
}
