import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/agents/banner_agent/banner_dismiss_params.dart';
import 'package:flutter_easy_dialogs/src/agents/banner_agent/banner_show_params.dart';
import 'package:flutter_easy_dialogs/src/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/widgets/easy_dialogs/easy_dialogs_theme.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs]
class EasyDialogsController {
  final DialogAgentBase _bannerAgent;

  /// Data of [EasyDialogsTheme]
  EasyDialogsThemeData? _theme;

  /// Craetes instance of [EasyDialogsController]
  EasyDialogsController({
    required DialogAgentBase bannerAgent,
  }) : _bannerAgent = bannerAgent;

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyDialogsController &&
        _theme == other._theme &&
        _bannerAgent == other._bannerAgent;
  }

  @override
  int get hashCode {
    final values = [
      _theme,
      _bannerAgent,
    ];

    return Object.hashAll(values);
  }

  /// Updates [EasyDialogsThemeData] of [EasyDialogsController]
  void updateTheme(EasyDialogsThemeData theme) {
    if (theme == _theme) return;

    _theme = theme;
  }

  /// Shows material banner
  Future<void> showBanner({
    required Widget content,
    EasyDialogPosition position = EasyDialogPosition.top,
    EasyDialogsAnimationType animationType = EasyDialogsAnimationType.slide,
    bool autoHide = false,
    Duration? durationUntilHide,
    Color? backgroundColor,
  }) async {
    await _bannerAgent.show(
      params: BannerShowParams(
        animationType: animationType,
        position: position,
        autoHide: autoHide,
        durationUntilHide: durationUntilHide,
        content: content,
        theme: _theme!,
      ),
    );
  }

  Future<void> dismissBanner({
    required EasyDialogPosition position,
    bool dismissAll = false,
  }) async {
    await _bannerAgent.hide(
      params: BannerDismissParams(
        dismissAll: dismissAll,
        position: position,
      ),
    );
  }
}
