import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/agents/positioned_dialog_agent/positioned_dialog_hide_params.dart';

import 'positioned_dialog_show_params.dart';

/// ### Agent for showing positioned dialog
/// Only single dialog of concrete [EasyDialogPosition] can be presented at the
/// same time
///
/// It's developer's responsibility to properly manage positioned dialogs
class PositionedDialogAgent extends EasyDialogAgentBase {
  /// [Map] of currently presented dialogs
  /// Contains position of the dialog and associated [AnimationController]
  final _currentDialogs = <EasyDialogPosition, AnimationController>{};

  /// Factory
  final IEasyDialogFactory _dialogFactory;

  /// Creates an instance of [PositionedDialogAgent]
  PositionedDialogAgent({
    required super.overlayController,
    required IEasyDialogFactory dialogFactory,
  }) : _dialogFactory = dialogFactory;

  @override
  Future<void> hide({
    required PositionedDialogHideParams params,
  }) async {
    if (params.hideAll && _currentDialogs.isNotEmpty) {
      final tasks = _currentDialogs.entries.map<Future<void>>(
        (e) => _hide(
          position: e.key,
          animationController: e.value,
          removeFromCurrentDialogs: false,
        ),
      );

      await Future.wait(tasks);
      _currentDialogs.clear();

      return;
    }
    if (params.position == null) return;

    final animationController =
        _getAnimationControllerOfPosition(params.position!);

    if (animationController == null) return;

    await _hide(
      position: params.position!,
      animationController: animationController,
    );
  }

  @override
  Future<void> show({
    required PositionedDialogShowParams params,
  }) async {
    final existingDialogAnimationController = _getAnimationControllerOfPosition(
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

    super.overlayController.insertPositionedDialog(
          dialog: dialog,
          position: params.position,
        );

    _addAnimationControllerOfPosition(
      params.position,
      newAnimationController,
    );

    await newAnimationController.forward();

    if (!params.autoHide) return;

    await Future.delayed(
      params.durationUntilHide ??
          params.theme.easyBannerTheme.durationUntilAutoHide,
    );

    final animationControllerOfPosition =
        _getAnimationControllerOfPosition(params.position);

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
    required PositionedDialogShowParams params,
  }) {
    return AnimationController(
      vsync: super.overlayController,
      duration: params.animationSettings?.duration ??
          params.theme.easyBannerTheme.forwardDuration,
      reverseDuration: params.animationSettings?.reverseDuration ??
          params.theme.easyBannerTheme.reverseDuration,
    );
  }

  Widget _createDialog({
    required PositionedDialogShowParams params,
    required AnimationController animationController,
  }) {
    final dialog = _dialogFactory.createDialog(params: params);

    final animation = _dialogFactory.createAnimation(params: params);

    final animatedDialog =
        animation.animate(parent: animationController, child: dialog);

    if (params.dismissibleType == EasyPositionedDismissibleType.none) {
      return animatedDialog;
    }

    final dismissible = _dialogFactory.createDismissible(
      params: params,
      handleOnDismissed: () => _hide(
        position: params.position,
        animationController: animationController,
      ),
    );

    return dismissible.makeDismissible(animatedDialog);
  }

  Future<void> _hide({
    required EasyDialogPosition position,
    required AnimationController animationController,
    bool removeFromCurrentDialogs = true,
  }) async {
    await animationController.reverse();
    animationController.dispose();

    super.overlayController.removePositionedDialog(
          position: position,
        );

    if (removeFromCurrentDialogs) _currentDialogs.remove(position);
  }

  AnimationController? _getAnimationControllerOfPosition(
    EasyDialogPosition position,
  ) =>
      _currentDialogs[position];

  void _addAnimationControllerOfPosition(
    EasyDialogPosition position,
    AnimationController controller,
  ) =>
      _currentDialogs[position] = controller;
}
