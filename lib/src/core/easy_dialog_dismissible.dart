import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';

/// {@category Decorators}
/// {@category Custom}
/// Dismiss callback.
typedef OnEasyDismissed = void Function();

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
abstract base class EasyDialogDismissible extends EasyDialogDecorator {
  /// Creates an instance of [EasyDialogDismissible].
  const EasyDialogDismissible({
    this.onDismissed,
    this.hideOnDismiss = true,
  });

  /// Callback that fires when dialog get dismissed.
  final OnEasyDismissed? onDismissed;
  final bool hideOnDismiss;

  @protected
  void handleDismiss(covariant EasyDialog dialog) {
    onDismissed?.call();
    if (hideOnDismiss) dialog.requestHide();
  }
}
