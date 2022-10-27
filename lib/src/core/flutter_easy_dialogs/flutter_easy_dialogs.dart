import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';

import 'easy_dialog_scope.dart';
import 'easy_dialogs_theme.dart';

/// Service - helper for easy use different custom dialogs
class FlutterEasyDialogs extends StatelessWidget {
  /// Theme of [FlutterEasyDialogs]
  final EasyDialogsThemeData? theme;

  /// Child widget
  final Widget child;

  /// Creates instance of [FlutterEasyDialogs]
  const FlutterEasyDialogs({
    required this.child,
    this.theme,
    super.key,
  });

  static EasyDialogsController of(
    BuildContext context,
  ) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<EasyDialogsScope>()!
        .widget as EasyDialogsScope;

    return scope.controller;
  }

  /// For using in [MaterialApp.builder]
  static const builder = _builder;

  static TransitionBuilder _builder({
    EasyDialogsThemeData? theme,
  }) {
    return (context, child) => FlutterEasyDialogs(
          theme: theme,
          child: child ?? const SizedBox.shrink(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return EasyDialogsTheme(
      data: theme ?? EasyDialogsThemeData.basic(),
      child: Material(
        child: EasyOverlay(
          initialEntries: [
            EasyOverlayEntry.app(
              builder: (context) => child,
            ),
          ],
        ),
      ),
    );
  }
}
