import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_widget.dart';

/// This class is derived from [InheritedWidget] and provides
/// specific [EasyDialogScopeData] to dialogs managed by [EasyDialogManager].
/// Typically, [EasyDialogManager] wraps the content to be shown in
/// several widgets,such as [EasyDialogShell], [EasyDialogAnimator],
/// or [EasyDialogDismissible], which consume this data for specific purposes.
class EasyDialogScope<T extends EasyDialogScopeData> extends InheritedWidget {
  /// Provided data.
  final T data;

  /// @nodoc
  const EasyDialogScope({
    required super.child,
    required this.data,
    super.key,
  });

  /// The typical convention for getting data provided by an [InheritedWidget]
  /// is to use a method named `of`.
  static T of<T extends EasyDialogScopeData>(BuildContext context) {
    return (context
            .getElementForInheritedWidgetOfExactType<EasyDialogScope<T>>()!
            .widget as EasyDialogScope<T>)
        .data;
  }

  /// Suppose that the data provided by [EasyDialogManager] into
  /// [EasyDialogScopeData] will never change, but even if that were to happen,
  /// there would be no need to react to any changes or notify any
  /// dependent children.
  @override
  bool updateShouldNotify(EasyDialogScope _) => false;
}

/// Base class to be provided within the [EasyDialogScope].
abstract class EasyDialogScopeData {
  /// @nodoc.
  const EasyDialogScopeData();
}
