// ignore_for_file: no-magic-number

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_manager.dart';

import 'positioned/manager/positioned_manager.dart';

/// Controller for manipulating dialogs via [FlutterEasyDialogs].
class EasyDialogsController implements IEasyDialogsController {
  final IEasyOverlayController _overlayController;
  late final _positionedManager =
      PositionedManager(overlayController: _overlayController);
  late final _fullScreenManager =
      FullScreenManager(overlayController: _overlayController);
  final Map<Type, EasyDialogManager> _customManagers;

  /// Creates an instance of [EasyDialogsController].
  EasyDialogsController({
    required IEasyOverlayController overlayController,
    required Map<Type, EasyDialogManager> customManagers,
  })  : _overlayController = overlayController,
        _customManagers = customManagers;

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyDialogsController &&
        _positionedManager == other._positionedManager &&
        _fullScreenManager == other._fullScreenManager &&
        _customManagers == other._customManagers;
  }

  @override
  int get hashCode {
    final values = [
      _positionedManager,
      _fullScreenManager,
      _customManagers,
    ];

    return Object.hashAll(values);
  }

  /// Show positioned dialog.
  @override
  Future<void> showPositioned({
    required PositionedShowParams params,
  }) {
    return _positionedManager.show(
      params: params,
    );
  }

  @override
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
  }) async {
    final animator = EasyPositionedAnimator.fromType(type: animationType);
    final dismissible = EasyPositionedDismissible.fromType(
      type: dismissibleType,
      onDismiss: onDismissed,
    );

    await _positionedManager.show(
      params: PositionedShowParams(
        content: content,
        position: position,
        dismissible: dismissible,
        durationUntilHide: durationUntilHide ?? const Duration(seconds: 3),
        animator: animator,
        shell: EasyPositionedDialogShell.banner(
          backgroundColor: backgroundColor,
          padding: padding ?? const EdgeInsets.all(10.0),
          margin: margin ?? EdgeInsets.zero,
          borderRadius: borderRadius == null
              ? BorderRadius.zero
              : BorderRadius.circular(borderRadius),
        ),
        autoHide: autoHide,
      ),
    );
  }

  @override
  @Deprecated('Use `hidePositioned` instead. Will be removed in 2.1.0')
  Future<void> hideBanner({
    required EasyDialogPosition position,
  }) async {
    await _positionedManager.hide(
      params: PositionedHideParams(
        position: position,
      ),
    );
  }

  @override
  @Deprecated('Use `hideAllPositioned` instead. Will be removed in 2.1.0')
  Future<void> hideAllBanners() async {
    await _positionedManager.hide(
      params: const PositionedHideParams(
        hideAll: true,
      ),
    );
  }

  /// Hide positioned dialog.
  @override
  Future<void> hidePositioned({
    required EasyDialogPosition position,
  }) async {
    await _positionedManager.hide(
      params: PositionedHideParams(
        position: position,
      ),
    );
  }

  /// Hide all positioned dialogs.
  @override
  Future<void> hideAllPositioned() async {
    await _positionedManager.hide(
      params: PositionedHideParams(
        hideAll: true,
      ),
    );
  }

  @override
  Future<void> showFullScreen({
    required FullScreenShowParams params,
  }) =>
      _fullScreenManager.show(params: params);

  @override
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
  }) async {
    final backgroundAnimator = EasyFullScreenBackgroundAnimator.fromType(
      type: backgroundAnimationType,
      backgroundColor: backgroundColor,
    );

    final foreGroundAnimator =
        EasyFullScreenForegroundAnimator.fromType(type: contentAnimationType);

    await _fullScreenManager.show(
      params: FullScreenShowParams(
        content: content,
        shell: EasyFullScreenDialogShell.modalBanner(
          padding: padding ?? const EdgeInsets.all(60.0),
          margin: margin ?? const EdgeInsets.symmetric(horizontal: 15.0),
          boxDecoration: decoration,
        ),
        dismissible: EasyFullScreenDismissible.gesture(onDismiss: onDismissed),
        foregroundAnimator: foreGroundAnimator,
        backgroundAnimator: backgroundAnimator,
      ),
    );
  }

  @override
  @Deprecated('Use `hideFullScreen` instead. Will be removed in 2.1.0')
  Future<void> hideModalBanner() => _fullScreenManager.hide();

  /// Hide full screen dialog.
  @override
  Future<void> hideFullScreen() => _fullScreenManager.hide();

  @override
  T useCustom<T extends EasyDialogManager>() {
    assert(
      _customManagers.containsKey(T),
      'You should register agent named $T before calling it',
    );

    return _customManagers[T]! as T;
  }
}
