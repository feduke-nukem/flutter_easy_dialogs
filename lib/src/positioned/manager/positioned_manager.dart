import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_scope.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';
import 'package:flutter_easy_dialogs/src/positioned/util/easy_dialog_position_x.dart';
import 'package:flutter_easy_dialogs/src/positioned/widgets/easy_positioned_dialog_shell/easy_positioned_dialog_shell.dart';
import 'package:flutter_easy_dialogs/src/positioned/easy_dialog_position.dart';

import 'positioned_hide_params.dart';
import 'positioned_show_params.dart';

export 'positioned_hide_params.dart';
export 'positioned_show_params.dart';

part 'strategy.dart';
part 'dialogs_map.dart';

typedef EasyPositionedDialogBuilder<T> = Widget Function(
  Widget content,
  EasyDialogPosition position,
);

/// ### Manager for showing positioned dialog.
///
/// Only single dialog of concrete [EasyDialogPosition] can be presented at the
/// same time.
///
/// It's developer's responsibility to properly manage positioned dialogs.
class PositionedManager
    extends EasyDialogManager<PositionedShowParams, PositionedHideParams> {
  /// [Map] of currently presented dialogs.
  ///
  /// Contains position of the dialog and associated [AnimationController].
  final _dialogsMap = _DialogsMap();

  /// Creates an instance of [PositionedManager].
  PositionedManager({required super.overlayController});

  @override
  Future<void> hide({required PositionedHideParams params}) async {
    if (params.hideAll && _dialogsMap.isNotEmpty) {
      await _hideAll();

      return;
    }

    final position = params.position;

    if (position == null) return;

    final animationController = _dialogsMap.getController(position);

    if (animationController == null) return;

    await _hide(
      position: position,
      animationController: animationController,
    );
  }

  @override
  Future<void> show({required PositionedShowParams params}) async {
    final existingDialogAnimationController = _dialogsMap.getController(
      params.position,
    );

    if (existingDialogAnimationController != null) {
      await _hide(
        position: params.position,
        animationController: existingDialogAnimationController,
      );
    }

    final newAnimationController = _createAnimationController(params: params);

    final dialog = _createDialog(
      params: params,
      animationController: newAnimationController,
    );

    super.overlayController.insertDialog(
          PositionedDialogInsertStrategy(
            position: params.position,
            dialog: dialog,
          ),
        );

    _addAnimationControllerOfPosition(
      params.position,
      newAnimationController,
    );

    await newAnimationController.forward();

    if (!params.autoHide) return;

    await Future.delayed(params.durationUntilHide);

    final animationControllerOfPosition =
        _dialogsMap.getController(params.position);

    final shouldHide = identical(
      newAnimationController,
      animationControllerOfPosition,
    );

    if (!shouldHide) return;

    await _hide(
      position: params.position,
      animationController: newAnimationController,
    );
  }

  AnimationController _createAnimationController({
    required PositionedShowParams params,
  }) {
    return AnimationController(
      value: params.animationConfiguration.startValue,
      duration: params.animationConfiguration.duration,
      reverseDuration: params.animationConfiguration.reverseDuration,
      lowerBound: params.animationConfiguration.lowerBound,
      upperBound: params.animationConfiguration.upperBound,
      vsync: super.overlayController,
    );
  }

  Widget _createDialog({
    required PositionedShowParams params,
    required AnimationController animationController,
  }) {
    final dialog = params.shell;

    final dismissibleDialog = EasyDialogScope(
      data: EasyDismissibleScopeData(
        handleDismiss: () => _hide(
          position: params.position,
          animationController: animationController,
        ),
      ),
      child: params.dismissible.makeDismissible(dialog),
    );

    final animatedDialog = params.animator.animate(
      parent: animationController,
      child: dismissibleDialog,
    );

    return EasyDialogScope(
      data: EasyPositionedScopeData(
        position: params.position,
        content: params.content,
      ),
      child: Align(
        alignment: params.position.toAlignment(),
        child: animatedDialog,
      ),
    );
  }

  Future<void> _hide({
    required EasyDialogPosition position,
    required AnimationController animationController,
    bool removeFromCurrentDialogs = true,
  }) async {
    await animationController.reverse();
    animationController.dispose();

    super.overlayController.removeDialog(
          PositionedDialogRemoveStrategy(position: position),
        );

    if (removeFromCurrentDialogs) _dialogsMap.removeController(position);
  }

  Future<void> _hideAll() async {
    final tasks = _dialogsMap.entries.map<Future<void>>(
      (e) => _hide(
        position: e.key,
        animationController: e.value,
        removeFromCurrentDialogs: false,
      ),
    );

    await Future.wait(tasks);
    _dialogsMap.clear();
  }

  void _addAnimationControllerOfPosition(
    EasyDialogPosition position,
    AnimationController controller,
  ) =>
      _dialogsMap.addController(position, controller);
}
