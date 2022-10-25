import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation_settings.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_theme.dart';

abstract class DialogAgentBase {
  @protected
  @nonVirtual
  final IEasyDialogsOverlayController overlayController;

  const DialogAgentBase({
    required this.overlayController,
  });

  Future<void> show({
    required covariant ShowParams params,
  });

  Future<void> hide({
    required covariant DismissParams params,
  });
}

abstract class ShowParams {
  final Widget content;
  final EasyDialogsThemeData theme;
  final EasyDialogsAnimationSettings? animationSettings;

  const ShowParams({
    required this.theme,
    required this.content,
    this.animationSettings,
  });
}

abstract class DismissParams {
  const DismissParams();
}
