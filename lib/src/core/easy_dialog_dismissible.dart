import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_scope.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_manager.dart';
import 'package:flutter_easy_dialogs/src/positioned/dismissible/easy_positioned_dismissible.dart';
import 'package:flutter_easy_dialogs/src/positioned/manager/positioned_manager.dart';

import '../full_screen/dismissible/easy_full_screen_dismissible.dart';

/// Dismiss callback.
typedef OnEasyDismiss = void Function();

/// Base class of dismissible.
///
/// It is a different kind of abstraction than [IEasyDialogDismissible] as it
/// can possibly be extended with functionality and some properties in future.
abstract class EasyDialogDismissible implements IEasyDialogDismissible {
  /// Callback that fires when dialog get dismissed.
  final OnEasyDismiss? onDismiss;

  /// Creates an instance of [EasyDialogDismissible].
  const EasyDialogDismissible({this.onDismiss});
}

/// The main purpose is to make provided dialog dismissible.
/// It is often used in the [EasyDialogManager.show] method,
/// which provides the dialog to be used in the [makeDismissible] method.
///
/// See also:
/// * [FullScreenManager.show].
/// * [PositionedManager.show].
///
/// This may help you understand how it is supposed to work or even
/// create your own custom [EasyDialogManager].
abstract class IEasyDialogDismissible {
  /// ### Provide dismissible functionality to the [dialog].
  Widget makeDismissible(Widget dialog);
}

/// This is specific to the [EasyDialogDismissible] scope data.
/// Sometimes it is necessary to perform certain actions when the actual
/// [EasyDialogDismissible.onDismiss] callback is called.
///
/// For example, in [PositionedManager.show], before the dialog is dismissed,
/// it should trigger the dialog to hide and play an animation back.
///
/// So in this case, it makes sense to provide an optional [handleDismiss]
/// callback to [EasyDialogDismissible] implementations.
///
/// See also:
///
/// * [EasyPositionedDismissible].
/// * [EasyFullScreenDismissible].
class EasyDismissibleScopeData extends EasyDialogScopeData {
  final VoidCallback? handleDismiss;

  const EasyDismissibleScopeData({this.handleDismiss});

  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is EasyDismissibleScopeData && handleDismiss == other.handleDismiss;

  @override
  int get hashCode => Object.hashAll([handleDismiss]);
}
