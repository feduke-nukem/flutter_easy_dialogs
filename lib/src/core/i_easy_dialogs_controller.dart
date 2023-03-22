import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs].
abstract class IEasyDialogsController {
  /// Show positioned dialog.
  Future<void> showPositioned({
    required PositionedShowParams params,
  });

  @Deprecated('Use `showPositioned` instead. Will be removed in 2.1.0')
  Future<void> showBanner({
    required Widget content,
    EasyDialogPosition position = EasyDialogPosition.top,
    EasyPositionedAnimationType animationType =
        EasyPositionedAnimationType.slide,
    EasyPositionedDismissibleType dismissibleType =
        EasyPositionedDismissibleType.tap,
    OnEasyDismiss? onDismissed,
    bool autoHide = false,
    Duration? durationUntilHide,
    Color? backgroundColor,
    double? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
  });

  @Deprecated('Use `hidePositioned` instead. Will be removed in 2.1.0')
  Future<void> hideBanner({
    required EasyDialogPosition position,
  });

  @Deprecated('Use `hideAllPositioned` instead. Will be removed in 2.1.0')
  Future<void> hideAllBanners();

  /// Hide positioned dialog.
  Future<void> hidePositioned({
    required EasyDialogPosition position,
  });

  /// Hide all positioned dialogs.
  Future<void> hideAllPositioned();

  Future<void> showFullScreen({
    required FullScreenShowParams params,
  });

  @Deprecated('Use `showFullScreen` instead. Will be removed in 2.1.0')
  Future<void> showModalBanner({
    required Widget content,
    Color? backgroundColor,
    EasyFullScreenContentAnimationType contentAnimationType =
        EasyFullScreenContentAnimationType.bounce,
    EasyFullScreenBackgroundAnimationType backgroundAnimationType =
        EasyFullScreenBackgroundAnimationType.blur,
    BoxDecoration? decoration,
    OnEasyDismiss? onDismissed,
    EdgeInsets? padding,
    EdgeInsets? margin,
    IEasyDialogAnimator? customBackgroundAnimation,
    IEasyDialogAnimator? customContentAnimation,
  });

  @Deprecated('Use `hideFullScreen` instead. Will be removed in 2.1.0')
  Future<void> hideModalBanner();

  /// Hide full screen dialog.
  Future<void> hideFullScreen();

  T useCustom<T extends EasyDialogManager>();
}
