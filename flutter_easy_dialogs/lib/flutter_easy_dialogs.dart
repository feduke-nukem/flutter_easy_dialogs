library flutter_easy_dialogs;

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_dialog_manager_controller.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_overlay_app_entry.dart';

import 'src/overlay/easy_dialogs_overlay.dart';

export 'src/common/managers/mixin/block_android_back_button_mixin.dart';
export 'src/common/managers/mixin/single_auto_disposal_controller_mixin.dart';
export 'src/core/easy_dialog_animator.dart';
export 'src/core/easy_dialog_manager.dart';
export 'src/core/i_easy_dialog_manager_controller.dart';
export 'src/core/easy_dialog_dismissible.dart';
export 'src/core/easy_dialog_animator_configuration.dart';
export 'src/core/easy_dialog_decorator.dart';
export 'src/core/i_easy_overlay_controller.dart';
export 'src/util/multiply_animation.dart';
export 'src/core/i_easy_dialogs_manager_registrar.dart';

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

  /// Gets [IEasyDialogManagerController].
  static IEasyDialogManagerController get controller =>
      _key.currentState!.dialogManagerController;

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
