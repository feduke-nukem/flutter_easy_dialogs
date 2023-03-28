import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_dialog_manager_provider.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_overlay_app_entry.dart';

/// Wrapper for providing an easy use of different custom dialogs.
class FlutterEasyDialogs extends StatelessWidget {
  final EasyDialogSetupManagers? setupManagers;

  /// Child widget.
  final Widget child;

  /// Creates an instance of [FlutterEasyDialogs].
  const FlutterEasyDialogs({
    required this.child,
    this.setupManagers,
    super.key,
  });

  static final _key = GlobalKey<EasyDialogsOverlayState>();

  /// Gets [IEasyDialogManagerProvider].
  static IEasyDialogManagerProvider get provider =>
      _key.currentState!.dialogManagerProvider;

  /// For using in [MaterialApp.builder].
  static const builder = _builder;

  static TransitionBuilder _builder({
    EasyDialogSetupManagers? setupManagers,
  }) {
    return (context, child) => FlutterEasyDialogs(
          setupManagers: setupManagers,
          child: child ?? const SizedBox.shrink(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: EasyDialogsOverlay(
        setupManagers: setupManagers,
        initialEntries: [EasyOverlayAppEntry(builder: (context) => child)],
        key: _key,
      ),
    );
  }
}
