import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/custom/manager/custom_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/positioned/dismissible/positioned_dismissible.dart';
import 'package:flutter_easy_dialogs/src/positioned/manager/positioned_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dismissible/full_screen_dismissible.dart';

/// Dismiss callback.
typedef OnEasyDismissed = void Function();

/// The main purpose is to make provided [EasyDismissibleData.dialog]
/// dismissible.
///
/// It is often used in the [EasyDialogManager.show] method,
/// which provides the dialog to be used in the [decorate] method.
///
/// See also:
/// * [FullScreenDialogManager.show].
/// * [PositionedDialogManager.show].
///
/// This may help you understand how it is supposed to work or even
/// create your own [CustomDialogManager].
abstract class EasyDialogDismissible
    extends EasyDialogDecorator<EasyDismissibleData> {
  /// Callback that fires when dialog get dismissed.
  final OnEasyDismissed? onDismissed;

  /// Creates an instance of [EasyDialogDismissible].
  const EasyDialogDismissible({this.onDismissed});
}

/// This is specific to the [EasyDialogDismissible] data.
///
/// Sometimes it is necessary to perform certain actions when the actual
/// [EasyDialogDismissible.onDismissed] callback is called.
///
/// For example, in [PositionedDialogManager.show], before the dialog is dismissed,
/// it should trigger the dialog to hide and play an animation back.
///
/// So in this case, it makes sense to provide an optional [handleDismiss]
/// callback to [EasyDialogDismissible] implementations.
///
/// See also:
///
/// * [PositionedDismissible].
/// * [FullScreenDismissible].
class EasyDismissibleData extends EasyDialogDecoratorData {
  /// Optional callback.
  final VoidCallback? handleDismiss;

  /// @nodoc
  const EasyDismissibleData({required super.dialog, this.handleDismiss});
}
