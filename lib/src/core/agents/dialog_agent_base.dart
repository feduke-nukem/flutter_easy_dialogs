import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation_settings.dart'
    show EasyAnimationSettings;
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs/flutter_easy_dialogs_theme.dart'
    show FlutterEasyDialogsThemeData;
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart'
    show IEasyOverlayController;

/// Base class for all dialog agents
abstract class EasyDialogAgentBase<S, H> {
  /// [IEasyOverlayController] is used for providing [Ticker]
  /// for creating animations and inserting dialogs into [Overlay]
  @protected
  @nonVirtual
  final IEasyOverlayController overlayController;

  /// Creates an instance of [EasyDialogAgentBase]
  const EasyDialogAgentBase({
    required this.overlayController,
  });

  /// An abstract show method of dialog agent with covariant [params]
  /// This is the core method for displaying dialogs
  Future<void> show({
    required S params,
  });

  /// An abstract hide method of dialog agent with covariant [params]
  /// This is the core method for removing dialogs from the screen
  Future<void> hide({
    required H params,
  });
}

/// Core dto class of show params for dialog agents
abstract class AgentShowParams {
  /// Content for showing
  final Widget content;

  /// Theme
  final FlutterEasyDialogsThemeData theme;

  /// Animation settings
  final EasyAnimationSettings? animationSettings;

  /// Creates an instance of [AgentShowParams]
  const AgentShowParams({
    required this.theme,
    required this.content,
    this.animationSettings,
  });
}

/// Core dto class of hide params for dialog agents
abstract class AgentHideParams {
  /// Creates an instance of [AgentHideParams]
  const AgentHideParams();
}
