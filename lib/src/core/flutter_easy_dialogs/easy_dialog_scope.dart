import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs/easy_dialogs_controller.dart';

/// Inherited scope for providing [EasyDialogsController]
class EasyDialogsScope extends InheritedWidget {
  /// Instance of [EasyDialogsController]
  final EasyDialogsController controller;

  /// Creates instance of [EasyDialogsScope]
  const EasyDialogsScope({
    required super.child,
    required this.controller,
    super.key,
  });

  @override
  bool updateShouldNotify(EasyDialogsScope oldWidget) {
    return controller != oldWidget.controller;
  }
}
