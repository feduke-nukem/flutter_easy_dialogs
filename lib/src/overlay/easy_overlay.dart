import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_easy_dialogs/src/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_overlay_box.dart';

EasyDialogsController _createDialogController({
  required IEasyOverlayController overlayController,
  required List<EasyDialogManager> customManagersRaw,
}) {
  final customManagers = <EasyDialogManager>[];

  for (var customAgent in customManagersRaw) {
    assert(
      !customManagers.any(
        (agent) => agent.runtimeType == customAgent.runtimeType,
      ),
      'no duplicate type agents should be provided',
    );
    customManagers.add(customAgent);
  }

  final easyDialogsController = EasyDialogsController(
    overlayController: overlayController,
    customManagers: Map.fromIterable(
      customManagers,
      key: (customAgent) => customAgent.runtimeType,
    ),
  );

  return easyDialogsController;
}

/// Function for providing custom agents.
typedef CustomManagerBuilder = List<EasyDialogManager> Function(
  IEasyOverlayController overlayController,
);

/// Overlay for providing dialogs.
class EasyOverlay extends Overlay {
  /// Custom agent builder function.
  final CustomManagerBuilder? customManagersBuilder;

  /// Creates an instance of [EasyOverlay].
  const EasyOverlay({
    super.initialEntries = const <OverlayEntry>[],
    super.clipBehavior = Clip.hardEdge,
    this.customManagersBuilder,
    super.key,
  });

  @override
  EasyOverlayState createState() => EasyOverlayState();
}

class EasyOverlayState extends OverlayState implements IEasyOverlayController {
  @visibleForTesting
  final box = EasyOverlayBox();

  // Casting super.widget
  // ignore: avoid-returning-widgets
  @override
  EasyOverlay get widget => super.widget as EasyOverlay;

  late final IEasyDialogsController easyDialogsController =
      _createDialogController(
    overlayController: this,
    customManagersRaw: widget.customManagersBuilder?.call(this) ?? [],
  );

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
