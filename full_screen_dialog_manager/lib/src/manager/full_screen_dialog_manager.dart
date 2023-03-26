import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:full_screen_dialog_manager/src/manager/full_screen_hide_params.dart';
import 'package:full_screen_dialog_manager/src/manager/full_screen_show_params.dart';

export 'full_screen_hide_params.dart';
export 'full_screen_show_params.dart';

part 'strategy.dart';

/// ### Manager for displaying full screen dialogs.
///
/// Only one full-screen dialog can be presented at a time.
///
/// If a dialog is already presented and a new one is intended to be shown,
/// the previous one will be hidden before the next one is shown.
class FullScreenDialogManager
    extends EasyDialogManager<FullScreenShowParams, FullScreenHideParams?>
    with SingleAutoDisposalControllerMixin, BlockAndroidBackButtonMixin {
  /// Creates an instance of [FullScreenDialogManager].
  FullScreenDialogManager({required super.overlayController});

  @override
  Future<void> hide({FullScreenHideParams? params}) async {
    if (!isPresented) return;

    await _hide();
  }

  @override
  Future<void> show({required FullScreenShowParams params}) async {
    if (isPresented) await _hide();

    blockBackButton();

    await initializeAndShow(
      params,
      (animation) => _createInsertStrategy(params, animation),
    );
  }

  EasyOverlayBoxInsert _createInsertStrategy(
    FullScreenShowParams params,
    Animation<double> animation,
  ) {
    final dialog = _createDialog(params, animation);

    return FullScreenDialogInsertStrategy(
      dialog: dialog,
    );
  }

  @override
  AnimationController createAnimationController(
    TickerProvider vsync,
    FullScreenShowParams params,
  ) =>
      params.animationConfiguration.createController(vsync);

  Widget _createDialog(
    FullScreenShowParams params,
    Animation<double> animation,
  ) {
    Widget dialog = params.shell.decorate(EasyDialogDecoratorData(
      dialog: params.content,
    ));

    final animator = params.customAnimator ??
        EasyDialogDecorator.combine<EasyDialogAnimatorData>(
          decorators: [
            params.foregroundAnimator,
            params.backgroundAnimator,
          ],
          nextDataBuilder: (nextDialog, oldData) => EasyDialogAnimatorData(
            parent: oldData.parent,
            dialog: nextDialog,
          ),
        );

    dialog = animator.decorate(EasyDialogAnimatorData(
      parent: animation,
      dialog: dialog,
    ));

    dialog = params.dismissible.decorate(EasyDismissibleData(
      dialog: dialog,
      dismissHandler: (payload) => _hide(!payload.instantDismiss),
    ));
    return dialog;
  }

  Future<void> _hide([bool animate = true]) async {
    await hideAndDispose(
      const FullScreenDialogRemoveStrategy(),
      animate: animate,
    );

    unblockBackButton();
  }
}
