import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_overlay.dart';

/// {@category Dialogs}
/// {@category Getting started}
/// {@category Migration guide from 2.x to 3.x}
/// {@category FAQ}
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

  /// {@macro easy_dialogs_controller.show}
  static Future<T?> show<T extends Object?>(EasyDialog dialog) =>
      controller.show<T>(dialog);

  /// {@macro easy_dialogs_controller.hide}
  static Future<void> hide(
    EasyDialogIdentifier identifier, {
    bool instantly = false,
    Object? result,
  }) {
    return controller.hide(
      identifier,
      instantly: instantly,
      result: result,
    );
  }

  /// {@macro easy_dialogs_controller.hideWhere}
  static Future<void> hideWhere<T extends EasyDialog>(
    bool Function(T dialog) test, {
    bool instantly = false,
  }) {
    return controller.hideWhere<T>(test, instantly: instantly);
  }

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
