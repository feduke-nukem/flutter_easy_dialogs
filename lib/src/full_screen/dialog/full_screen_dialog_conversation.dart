import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/block_android_back_button_mixin.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dialog/full_screen_dialog.dart';

part 'insert.dart';

/// ### Manager for displaying full screen dialogs.
///
/// Only one full-screen dialog can be presented at a time.
///
/// If a dialog is already presented and a new one is intended to be shown,
/// the previous one will be hidden before the next one is shown.
final class FullScreenDialogConversation
    extends SingleDialogConversation<FullScreenDialog, FullScreenHide>
    with BlockAndroidBackButtonMixin {
  FullScreenDialogConversation();

  @override
  Future<void> begin(FullScreenDialog dialog) {
    blockBackButton();

    return super.begin(dialog);
  }

  @override
  Future<void> end(FullScreenHide hide) {
    unblockBackButton();

    return super.end(hide);
  }
}
