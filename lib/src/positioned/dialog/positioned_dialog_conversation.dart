import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_easy_dialogs/src/positioned/animation/positioned_animation.dart';
import 'package:flutter_easy_dialogs/src/positioned/dismissible/positioned_dismiss.dart';
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
    extends EasyDialogConversation<PositionedDialog, PositionedHiding> {
  @override
  Future<void> end(
    PositionedHiding hide, {
    bool instantly = false,
  }) =>
      switch (hide.position) {
        EasyDialogPosition.all => super.hideAll(instantly: instantly),
        _ => super.end(hide, instantly: instantly),
      };

  @override
  Future<T?> begin<T extends Object?>(PositionedDialog dialog) async {
    if (super.checkPresented(dialog)) await super.hide(dialog);

    return super.begin(dialog);
  }
}
