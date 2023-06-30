import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decoration.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';

/// {@category Decorators}
/// {@category Custom}
/// Dismiss callback.
typedef OnEasyDismissed<T> = FutureOr<T?> Function();
typedef EasyWillDismiss = Future<bool> Function();

/// {@category Decorators}
/// {@category Custom}
/// The main purpose is to make provided [EasyDismissibleData.dialog]
/// dismissible.
///
/// It is often used in the [EasyDialogsController.show] method,
/// which provides the dialog to be used in the [call] method.
///
/// This may help you understand how it is supposed to work or even
/// create your own [EasyDialogsController].
abstract base class EasyDialogDismiss<Dialog extends EasyDialog, T>
    extends EasyDialogDecoration<Dialog> {
  /// Callback that fires when dialog get dismissed.
  final OnEasyDismissed<T?>? onDismissed;
  final EasyWillDismiss? willDismiss;

  /// Creates an instance of [EasyDialogDismiss].
  const EasyDialogDismiss({
    this.onDismissed,
    this.willDismiss,
  });

  @protected
  Future<void> handleDismiss(Dialog dialog) async {
    final needHide = await willDismiss?.call() ?? true;
    if (needHide) dialog.context.hide(result: onDismissed?.call());
  }
}
