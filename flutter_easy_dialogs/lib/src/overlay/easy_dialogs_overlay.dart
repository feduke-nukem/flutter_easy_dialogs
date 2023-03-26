import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_dialog_manager_controller.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_dialogs_manager_registrar.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_easy_dialogs/src/easy_dialog_manager_controller/easy_dialog_manager_controller.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_overlay_app_entry.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_box.dart';

typedef EasyDialogSetupManagers = void Function(
  IEasyOverlayController overlayController,
  IEasyDialogsManagerRegistrar managerRegistrar,
);

/// Overlay for storing and displaying dialogs.
class EasyDialogsOverlay extends Overlay {
  final EasyDialogSetupManagers? setupManagers;

  /// Creates an instance of [EasyDialogsOverlay].
  const EasyDialogsOverlay({
    this.setupManagers,
    super.initialEntries = const <OverlayEntry>[],
    super.clipBehavior = Clip.hardEdge,
    super.key,
  });

  @override
  EasyDialogsOverlayState createState() => EasyDialogsOverlayState();
}

class EasyDialogsOverlayState extends OverlayState
    implements IEasyOverlayController {
  @visibleForTesting
  final box = EasyDialogsOverlayBox();

  // Casting super.widget
  // ignore: avoid-returning-widgets
  @override
  EasyDialogsOverlay get widget => super.widget as EasyDialogsOverlay;

  final _dialogManagerController = EasyDialogManagerController();

  /// @nodoc
  IEasyDialogManagerController get dialogManagerController =>
      _dialogManagerController;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<Map<Object?, Object?>>(
          '_currentEntries',
          // Just that
          // ignore: invalid_use_of_visible_for_testing_member
          box.currentEntries,
        ),
      )
      ..add(
        DiagnosticsProperty<EasyOverlayAppEntry?>('appEntry', box.appEntry),
      );
  }

  @override
  void initState() {
    super.initState();
    widget.setupManagers?.call(this, _dialogManagerController);
  }

  @override
  void insert(
    OverlayEntry entry, {
    OverlayEntry? below,
    OverlayEntry? above,
  }) {
    if (entry is EasyOverlayAppEntry ||
        below is EasyOverlayAppEntry ||
        above is EasyOverlayAppEntry) {
      assert(
        box.appEntry == null,
        'Only one $EasyOverlayAppEntry can be presented at the same time',
      );

      box.appEntry = entry as EasyOverlayAppEntry;
    }

    super.insert(entry, below: below, above: above);
  }

  @override
  void insertDialog(EasyOverlayBoxInsert strategy) =>
      insert(strategy.apply(box));

  @override
  void removeDialog(EasyOverlayBoxRemove strategy) =>
      strategy.apply(box)?.remove();
}
