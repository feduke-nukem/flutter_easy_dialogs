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
    extends EasyDialogConversation<PositionedDialog, PositionedHide> {
  @override
  Future<void> end(PositionedHide hide) async {
    if (hide.hideAll && super.entries.isNotEmpty) {
      await super.releaseAll(animate: true);

      return;
    }

    return super.end(hide);
  }

  @override
  Future<void> begin(PositionedDialog dialog) async {
    await _hideIfExists(dialog);

    await super.begin(dialog);
    final newController = super.entries[dialog.identifier]!.animationController;

    await _maybeAutoHide(
      dialog: dialog,
      newController: newController,
    );
  }

  Future<void> _maybeAutoHide({
    required PositionedDialog dialog,
    required AnimationController newController,
  }) async {
    if (dialog.hideAfterDuration == null) return;

    await Future.delayed(dialog.hideAfterDuration!);

    final previousController =
        super.entries[dialog.identifier]!.animationController;

    final shouldHide = identical(newController, previousController);

    if (!shouldHide) return;

    await releaseEntry(entries[dialog.identifier]!, animate: true);
  }

  Future<void> _hideIfExists(PositionedDialog dialog) async {
    final entry = super.entries[dialog.identifier];

    if (entry == null) return;

    await super.releaseEntry(entry, animate: true);
  }
}
