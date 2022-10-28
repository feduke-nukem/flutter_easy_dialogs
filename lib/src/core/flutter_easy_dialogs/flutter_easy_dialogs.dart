import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';

import 'easy_dialog_scope.dart';
import 'flutter_easy_dialogs_theme.dart';

/// Service - helper for easy use different custom dialogs
class FlutterEasyDialogs extends StatelessWidget {
  /// Theme of [FlutterEasyDialogs]
  final FlutterEasyDialogsThemeData? theme;

  final CustomAgentBuilder? customAgentBuilder;

  /// Child widget
  final Widget child;

  /// Creates instance of [FlutterEasyDialogs]
  const FlutterEasyDialogs({
    required this.child,
    this.customAgentBuilder,
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
    FlutterEasyDialogsThemeData? theme,
    CustomAgentBuilder? customAgentBuilder,
  }) {
    return (context, child) => FlutterEasyDialogs(
          theme: theme,
          customAgentBuilder: customAgentBuilder,
          child: child ?? const SizedBox.shrink(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyDialogsTheme(
      data: theme ?? FlutterEasyDialogsThemeData.basic(),
      child: Material(
        child: EasyOverlay(
          customAgentBuilder: customAgentBuilder,
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
