import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:positioned_dialog_manager/src/animation/positioned_animator.dart';
import 'package:positioned_dialog_manager/src/dismissible/positioned_dismissible.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';
import 'package:positioned_dialog_manager/src/shell/positioned_dialog_shell/positioned_dialog_shell.dart';

part 'positioned_hide_params.dart';
part 'positioned_show_params.dart';

part 'strategy.dart';
part 'animation_controller_box.dart';

/// ### Manager for showing positioned dialogs.
///
/// Only a single dialog with a specific [EasyDialogPosition] can be presented
/// at a time.
///
/// If a dialog with the same [EasyDialogPosition] is intended to be [show]n,
/// the current one will be hidden first.
class PositionedDialogManager
    extends EasyDialogManager<PositionedShowParams, PositionedHideParams> {
  /// [Map] of currently presented dialogs.
  ///
  /// Contains position of the dialog and associated [AnimationController].
  final _dialogsMap = AnimationControllerBox();

  /// Creates an instance of [PositionedDialogManager].
  PositionedDialogManager({required super.overlayController});

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

    if (params.hideAfterDuration == null) return;

    await Future.delayed(params.hideAfterDuration!);

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
    var dialog = params.shell.decorate(PositionedDialogShellData(
      position: params.position,
      dialog: params.content,
    ));

    dialog = params.animator.decorate(PositionedAnimatorData(
      position: params.position,
      parent: animationController.view,
      dialog: dialog,
    ));

    dialog = params.dismissible.decorate(PositionedDismissibleData(
      position: params.position,
      dialog: dialog,
      dismissHandler: (payload) => _hide(
        position: params.position,
        animationController: animationController,
        animate: !payload.instantDismiss,
      ),
    ));

    return Align(
      alignment: params.position.alignment,
      child: dialog,
    );
  }

  Future<void> _hide({
    required EasyDialogPosition position,
    required AnimationController animationController,
    bool animate = true,
    bool removeFromCurrentDialogs = true,
  }) async {
    if (animate) await animationController.reverse();

    animationController.dispose();

    overlayController
        .removeDialog(PositionedDialogRemoveStrategy(position: position));

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
