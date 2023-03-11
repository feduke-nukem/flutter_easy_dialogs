import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/managers/full_screen_dialog_manager/full_screen_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/core/managers/positioned_dialog_manager/positioned_dialog_hide_params.dart';
import 'package:flutter_easy_dialogs/src/core/managers/positioned_dialog_manager/positioned_dialog_manager.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs]
class EasyDialogsController {
  final PositionedDialogManager _bannerManager;
  final FullScreenDialogManager _modalBannerManager;
  final Map<Type, EasyDialogManagerBase> _customManagers;

  /// Data of [FlutterEasyDialogsTheme]
  FlutterEasyDialogsThemeData? _theme;

  /// Creates an instance of [EasyDialogsController]
  EasyDialogsController({
    required PositionedDialogManager bannerManager,
    required FullScreenDialogManager modalBannerManager,
    required Map<Type, EasyDialogManagerBase> customManagers,
  })  : _bannerManager = bannerManager,
        _modalBannerManager = modalBannerManager,
        _customManagers = customManagers;

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyDialogsController &&
        _theme == other._theme &&
        _bannerManager == other._bannerManager;
  }

  @override
  int get hashCode {
    final values = [
      _theme,
      _bannerManager,
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
    await _bannerManager.show(
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
        borderRadius: borderRadius,
        theme: _theme!,
      ),
    );
  }

  /// Hide banner
  Future<void> hideBanner({
    required EasyDialogPosition position,
  }) async {
    await _bannerManager.hide(
      params: PositionedDialogHideParams(
        position: position,
      ),
    );
  }

  /// Hide all positioned banners
  Future<void> hideAllBanners() async {
    await _bannerManager.hide(
      params: const PositionedDialogHideParams(
        hideAll: true,
      ),
    );
  }

  /// Show full screen modal banner
  Future<void> showModalBanner({
    required Widget content,
    Color? backgroundColor,
    EasyFullScreenContentAnimationType contentAnimationType =
        EasyFullScreenContentAnimationType.bounce,
    EasyFullScreenBackgroundAnimationType backgroundAnimationType =
        EasyFullScreenBackgroundAnimationType.blur,
    BoxDecoration? decoration,
    EasyDismissCallback? onDismissed,
    EdgeInsets? padding,
    EdgeInsets? margin,
    IEasyAnimator? customBackgroundAnimation,
    IEasyAnimator? customContentAnimation,
  }) async {
    await _modalBannerManager.show(
      params: EasyModalBannerShowParams(
        theme: _theme!,
        backgroundColor: backgroundColor,
        onDismissed: onDismissed,
        decoration: decoration,
        content: content,
        backgroundAnimationType: backgroundAnimationType,
        contentAnimationType: contentAnimationType,
        padding: padding,
        margin: margin,
        customBackgroundAnimation: customBackgroundAnimation,
        customContentAnimation: customContentAnimation,
      ),
    );
  }

  /// Hide full screen modal banner
  Future<void> hideModalBanner() => _modalBannerManager.hide();

  T useCustom<T extends EasyDialogManagerBase>() {
    assert(
      _customManagers.containsKey(T),
      'You should register agent named $T before calling it',
    );
    return _customManagers[T]! as T;
  }
}
