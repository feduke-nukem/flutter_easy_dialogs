import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_easy_dialogs/src/positioned/animation/positioned_animator.dart';
import 'package:flutter_easy_dialogs/src/positioned/dismissible/positioned_dismissible.dart';
import 'package:flutter_easy_dialogs/src/positioned/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/positioned/shell/positioned_dialog_shell.dart';

part 'positioned_dialog.dart';

part 'insert.dart';

/// ### Manager for showing positioned dialogs.
///
/// Only a single dialog with a specific [EasyDialogPosition] can be presented
/// at a time.
///
/// If a dialog with the same [EasyDialogPosition] is intended to be [show]n,
/// the current one will be hidden first.
final class PositionedDialogConversation
    extends EasyDialogConversation<PositionedDialog, PositionedHide>
    with EasyDialogHiderMixin {
  @override
  Future<void> end(PositionedHide hide) async {
    if (hide.hideAll) {
      await super.hideAll();

      return;
    }

    return super.end(hide);
  }

  @override
  Future<void> begin(PositionedDialog dialog) async {
    if (super.checkPresented(dialog)) await super.hide(dialog);

    await super.begin(dialog);
    final newController = getControllerOf(dialog);

    if (dialog.hideAfterDuration == null) return;

    await Future.delayed(dialog.hideAfterDuration!);

    if (newController.isDismissed) return;

    await newController.reverse();
  }
}
