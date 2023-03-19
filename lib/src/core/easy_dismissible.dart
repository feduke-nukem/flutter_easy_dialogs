import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_scope.dart';

/// Dismiss callback.
typedef OnEasyDismiss = void Function();

/// Core class of dismissible.
abstract class EasyDismissible implements IEasyDismissible {
  /// Callback that fires when dialog get dismissed.
  final OnEasyDismiss? onDismiss;

  /// Creates an instance of [EasyDismissible].
  const EasyDismissible({
    this.onDismiss,
  });
}

/// Interface of dismissible.
abstract class IEasyDismissible {
  /// Make dialog dismissible.
  Widget makeDismissible(Widget dialog);
}

class EasyDismissibleScopeData extends EasyDialogScopeData {
  final VoidCallback? handleDismiss;

  const EasyDismissibleScopeData({
    this.handleDismiss,
  });

  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is EasyDismissibleScopeData && handleDismiss == other.handleDismiss;

  @override
  int get hashCode => Object.hashAll([handleDismiss]);
}
