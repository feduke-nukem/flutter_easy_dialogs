import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/full_screen_foreground_animator/full_screen_foreground_animator.dart'
    as foreground_animator;
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';

import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/common/managers/mixin/block_android_back_button_mixin.dart';
import 'package:flutter_easy_dialogs/src/common/managers/mixin/single_auto_disposal_controller_mixin.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';
import 'package:flutter_easy_dialogs/src/positioned/manager/positioned_dialog_manager.dart';

export 'full_screen_hide_params.dart';
export 'full_screen_show_params.dart';

part 'strategy.dart';

const _bounceDuration = Duration(milliseconds: 180);
const _bounceReverseDuration = Duration(milliseconds: 180);

/// ### Manager for displaying full screen dialogs.
///
/// Only one full-screen dialog can be presented at a time.
///
/// If a dialog is already presented and a new one is intended to be shown,
/// the previous one will be hidden before the next one is shown.
///
/// See also:
///
/// * [PositionedDialogManager].
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
      AnimationController(
        value: params.animationConfiguration.startValue,
        // TODO: Should fix bounce animation behaviour to remove that
        duration: params.foregroundAnimator is foreground_animator.Bounce
            ? _bounceDuration
            : params.animationConfiguration.duration,
        reverseDuration: params.foregroundAnimator is foreground_animator.Bounce
            ? _bounceReverseDuration
            : params.animationConfiguration.reverseDuration,
        debugLabel: 'FullScreen dialog manager',
        vsync: vsync,
      );

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

    dialog = params.dismissible.decorate(EasyDismissibleData(
      dialog: dialog,
      handleDismiss: _hide,
    ));

    dialog = animator.decorate(EasyDialogAnimatorData(
      parent: animation,
      dialog: dialog,
    ));

    return dialog;
  }

  Future<void> _hide() async {
    await hideAndDispose(const FullScreenDialogRemoveStrategy());

    unblockBackButton();
  }
}
