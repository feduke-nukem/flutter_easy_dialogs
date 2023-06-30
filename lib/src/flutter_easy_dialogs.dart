import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_overlay.dart';

/// Wrapper for providing an easy use of different custom dialogs.
final class FlutterEasyDialogs extends StatelessWidget {
  /// Child widget.
  final Widget child;

  /// Creates an instance of [FlutterEasyDialogs].
  const FlutterEasyDialogs({
    required this.child,
    super.key,
  });

  static final _key = GlobalKey<EasyDialogsOverlayState>();

  @visibleForTesting
  static EasyDialogsController get controller => _key.currentState!.controller;

  static Future<T?> show<T>(EasyDialog dialog) => controller.show<T>(dialog);
  static Future<void> hide(EasyDialogHiding hide) => controller.hide(hide);

  /// For using in [MaterialApp.builder].
  static const builder = _builder;

  static TransitionBuilder _builder() {
    return (context, child) => FlutterEasyDialogs(
          child: child ?? const SizedBox.shrink(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: EasyDialogsOverlay(
        initialEntries: [
          EasyOverlayAppEntry(builder: (context) => child),
        ],
        key: _key,
      ),
    );
  }
}
