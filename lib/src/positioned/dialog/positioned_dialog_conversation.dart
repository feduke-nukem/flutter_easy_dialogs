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
  Future<void> end(PositionedHiding hide) => switch (hide.position) {
        EasyDialogPosition.all => super.hideAll(),
        _ => super.end(hide),
      };

  @override
  Future<T?> begin<T>(PositionedDialog dialog) async {
    if (super.checkPresented(dialog)) await super.hide(dialog);

    final completer = Completer<T?>();

    super.begin<T>(dialog).then((value) => completer.complete(value));

    final newController = getAnimationController(dialog);

    if (dialog.hideAfterDuration == null) return completer.future;

    await Future.delayed(dialog.hideAfterDuration!);

    if (newController.isDismissed) return completer.future;

    await newController.reverse();

    return completer.future;
  }
}
