import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation_settings.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_theme.dart';

abstract class DialogAgentBase {
  const DialogAgentBase();

  Future<void> show({
    required covariant ShowParams params,
  });

  Future<void> dismiss({
    required covariant DismissParams params,
  });
}

abstract class DialogAgentParams {
  final IEasyDialogsOverlayController overlayController;

  const DialogAgentParams({
    required this.overlayController,
  });
}

abstract class ShowParams extends DialogAgentParams {
  final Widget content;
  final EasyDialogsThemeData theme;
  final EasyDialogsAnimationSettings? animationSettings;

  const ShowParams({
    required this.theme,
    required this.content,
    required super.overlayController,
    this.animationSettings,
  });
}

abstract class DismissParams extends DialogAgentParams {
  const DismissParams({
    required super.overlayController,
  });
}
