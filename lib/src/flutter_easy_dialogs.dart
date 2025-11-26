import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_easy_dialogs/src/core/widget/overlay_provider.dart';

/// {@category Dialogs}
/// {@category Getting started}
/// {@category Migration guide from 2.x to 3.x}
/// {@category FAQ}
/// Wrapper for providing an easy use of different custom dialogs.
class FlutterEasyDialogs extends StatelessWidget {
  /// Child widget.
  final Widget child;

  /// Creates an instance of [FlutterEasyDialogs].
  const FlutterEasyDialogs({
    required this.child,
    super.key,
  });

  static EasyDialogsController get controller =>
      OverlayProvider.stateKey.currentState!.controller;

  /// {@macro easy_dialogs_controller.show}
  static Future<T?> show<T extends Object?>(EasyDialog dialog) =>
      controller.show<T>(dialog);

  /// {@macro easy_dialogs_controller.hide}
  static Future<void> hide({
    required Object id,
    bool instantly = false,
    Object? result,
  }) {
    return controller.hide(
      id: id,
      instantly: instantly,
      result: result,
    );
  }

  /// {@macro easy_dialogs_controller.get}
  static EasyDialog get(Object id) => controller.get(id);

  /// {@macro easy_dialogs_controller.hideWhere}
  static Future<void> hideWhere<T extends EasyDialog>(
    bool Function(T dialog) test, {
    bool instantly = false,
  }) {
    return controller.hideWhere<T>(test, instantly: instantly);
  }

  /// {@macro easy_dialogs_controller.isShown}
  static bool isShown({required Object id}) => controller.isShown(id: id);

  /// For using in [MaterialApp.builder].
  static const builder = _builder;

  static TransitionBuilder _builder() => (context, child) =>
      FlutterEasyDialogs(child: child ?? const SizedBox.shrink());

  @override
  Widget build(BuildContext context) =>
      OverlayProvider(child: child, key: OverlayProvider.stateKey);
}
