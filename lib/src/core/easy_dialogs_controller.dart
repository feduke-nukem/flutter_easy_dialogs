import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/agents/banner/banner_hide_params.dart';
import 'package:flutter_easy_dialogs/src/core/agents/banner/banner_show_params.dart';
import 'package:flutter_easy_dialogs/src/core/agents/positioned_dialog_agent.dart/positioned_dialog_agent.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs]
class EasyDialogsController {
  final PositionedDialogAgent _bannerAgent;

  /// Data of [EasyDialogsTheme]
  EasyDialogsThemeData? _theme;

  /// Craetes instance of [EasyDialogsController]
  EasyDialogsController({
    required PositionedDialogAgent bannerAgent,
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
    EasyAnimationType animationType = EasyAnimationType.slide,
    EasyDismissibleType dismissibleType = EasyDismissibleType.tap,
    EasyDismissCallback? onDismissed,
    bool autoHide = false,
    Duration? durationUntilHide,
    Color? backgroundColor,
  }) async {
    await _bannerAgent.show(
      params: BannerShowParams(
        onDismissed: onDismissed,
        animationType: animationType,
        dismissibleType: dismissibleType,
        position: position,
        autoHide: autoHide,
        durationUntilHide: durationUntilHide,
        content: content,
        theme: _theme!,
      ),
    );
  }

  Future<void> hideBanner({
    required EasyDialogPosition position,
  }) async {
    await _bannerAgent.hide(
      params: BannerHideParams(
        position: position,
      ),
    );
  }

  Future<void> hideAllBanners() async {
    await _bannerAgent.hide(
      params: const BannerHideParams(
        hideAll: true,
      ),
    );
  }
}
