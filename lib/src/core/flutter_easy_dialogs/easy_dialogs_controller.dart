import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/agents/fullscreen_dialog_agent/fullscreen_dialog_agent.dart';
import 'package:flutter_easy_dialogs/src/core/agents/positioned_dialog_agent/positioned_dialog_agent.dart';
import 'package:flutter_easy_dialogs/src/core/agents/positioned_dialog_agent/positioned_dialog_hide_params.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/pre_built/easy_banner/easy_banner_show_params.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/pre_built/easy_modal_banner/easy_modal_banner_show_params.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs]
class EasyDialogsController {
  final PositionedDialogAgent _bannerAgent;
  final FullScreenDialogAgent _modalBannerAgent;
  final Map<String, EasyDialogAgentBase>? _customAgents;

  /// Data of [FlutterEasyDialogsTheme]
  FlutterEasyDialogsThemeData? _theme;

  /// Craetes an instance of [EasyDialogsController]
  EasyDialogsController({
    required PositionedDialogAgent bannerAgent,
    required FullScreenDialogAgent modalBannerAgent,
    Map<String, EasyDialogAgentBase>? customAgents,
  })  : _bannerAgent = bannerAgent,
        _modalBannerAgent = modalBannerAgent,
        _customAgents = customAgents;

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

  /// Updates [FlutterEasyDialogsThemeData] of [EasyDialogsController]
  void updateTheme(FlutterEasyDialogsThemeData theme) {
    if (theme == _theme) return;

    _theme = theme;
  }

  /// Shows material banner
  Future<void> showBanner({
    required Widget content,
    EasyDialogPosition position = EasyDialogPosition.top,
    EasyPositionedAnimationType animationType =
        EasyPositionedAnimationType.slide,
    EasyPositionedDismissibleType dismissibleType =
        EasyPositionedDismissibleType.tap,
    EasyDismissCallback? onDismissed,
    bool autoHide = false,
    Duration? durationUntilHide,
    Color? backgroundColor,
    double? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
  }) async {
    await _bannerAgent.show(
      params: EasyBannerShowParams(
        onDismissed: onDismissed,
        animationType: animationType,
        dismissibleType: dismissibleType,
        position: position,
        autoHide: autoHide,
        padding: padding,
        durationUntilHide: durationUntilHide,
        content: content,
        margin: margin,
        backgroundColor: backgroundColor,
        borderRaduius: borderRadius,
        theme: _theme!,
      ),
    );
  }

  /// Hide banner
  Future<void> hideBanner({
    required EasyDialogPosition position,
  }) async {
    await _bannerAgent.hide(
      params: PositionedDialogHideParams(
        position: position,
      ),
    );
  }

  /// Hide all positioned banners
  Future<void> hideAllBanners() async {
    await _bannerAgent.hide(
      params: const PositionedDialogHideParams(
        hideAll: true,
      ),
    );
  }

  /// Show fullscreen modal banner
  Future<void> showModalBanner({
    required Widget content,
    Color? backgroundColor,
    EasyFullScreenContentAnimationType contentAnimationType =
        EasyFullScreenContentAnimationType.bounce,
    EasyFullScreenBackgroungAnimationType backgroungAnimationType =
        EasyFullScreenBackgroungAnimationType.blur,
    BoxDecoration? decoration,
    EasyDismissCallback? onDismissed,
    EdgeInsets? padding,
    EdgeInsets? margin,
    IEasyAnimator? customBackgroundAnimation,
    IEasyAnimator? customContentAnimation,
  }) async {
    await _modalBannerAgent.show(
      params: EasyModalBannerShowParams(
        theme: _theme!,
        backgroundColor: backgroundColor,
        onDismissed: onDismissed,
        content: content,
        backgroungAnimationType: backgroungAnimationType,
        contentAnimationType: contentAnimationType,
        padding: padding,
        margin: margin,
        customBackgroungAnimation: customBackgroundAnimation,
        customContentAnimation: customContentAnimation,
      ),
    );
  }

  /// Hide fullscreen modal banner
  Future<void> hideModalBanner() => _modalBannerAgent.hide();

  /// Show custom dialog that belongs to a custom agent
  Future<void> showCustom({
    required String name,
    required AgentShowParams params,
  }) async {
    if (_customAgents == null) return;

    assert(
      _customAgents!.containsKey(name),
      'You should register agent named $name before calling it',
    );

    await _customAgents![name]!.show(params: params);
  }

  /// Hide custom dialog that belongs to a custom agent
  Future<void> hideCustom({
    required String name,
    AgentHideParams? params,
  }) async {
    if (_customAgents == null) return;
    assert(
      _customAgents!.containsKey(name),
      'You should register agent named $name before calling it',
    );

    await _customAgents![name]!.hide(params: params);
  }
}
