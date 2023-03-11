// ignore_for_file: unnecessary_overrides

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

import 'full_screen_dialog_hide_params.dart';
import 'full_screen_dialog_show_params.dart';

export 'full_screen_dialog_hide_params.dart';
export 'full_screen_dialog_show_params.dart';

/// ### Manager for displaying full screen dialogs
///
/// Only one full screen dialog can be presented at the same time
class FullScreenDialogManager
    extends EasyDialogManagerBase<FullScreenShowParams, FullScreenHideParams?>
    with SingleAutoDisposalControllerMixin, BlockAndroidBackButtonMixin {
  /// factory
  final IEasyDialogFactory _dialogFactory;

  /// Creates an instance of [FullScreenDialogManager]
  FullScreenDialogManager({
    required super.overlayController,
    required IEasyDialogFactory dialogFactory,
  }) : _dialogFactory = dialogFactory;

  @override
  Future<void> hide({FullScreenHideParams? params}) async {
    if (!isPresented) return;

    await _hide();
  }

  @override
  Future<void> show({required FullScreenShowParams params}) async {
    if (isPresented) await _hide();

    blockBackButton();

    await initializeAndShow(params);
  }

  @override
  void onAnimationInitialized(
    FullScreenShowParams params,
    Animation<double> animation,
  ) {
    final dialog = createDialog(params, animation);

    super.overlayController.insertDialog(
          EasyOverlayInsertStrategy.fullScreen(
            dialog: dialog,
          ),
        );
  }

  @override
  AnimationController createAnimationController(
    TickerProvider vsync,
    FullScreenShowParams params,
  ) {
    return AnimationController(
      vsync: vsync,
      duration: params.contentAnimationType ==
              EasyFullScreenContentAnimationType.bounce
          ? const Duration(milliseconds: 180)
          : const Duration(milliseconds: 300),
    );
  }

  @override
  Widget createDialog(
    FullScreenShowParams params,
    Animation<double> animation,
  ) {
    final modalBanner = _dialogFactory.createDialog(params: params);

    final animation = _dialogFactory.createAnimation(params: params);

    final animatedModalBanner = animation.animate(
      parent: super.animation,
      child: modalBanner,
    );

    if (params.onDismissed == null) return animatedModalBanner;

    return _dialogFactory
        .createDismissible(params: params)
        .makeDismissible(animatedModalBanner);
  }

  Future<void> _hide() async {
    try {
      await hideAndDispose();
    } finally {
      super
          .overlayController
          .removeDialog(EasyOverlayRemoveStrategy.fullScreen());

      unblockBackButton();
    }
  }
}
