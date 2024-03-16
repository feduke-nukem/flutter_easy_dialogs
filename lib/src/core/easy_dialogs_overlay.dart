import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/easy_overlay.dart';

/// Overlay for storing and displaying dialogs.
final class EasyDialogsOverlay extends Overlay {
  /// Creates an instance of [EasyDialogsOverlay].
  const EasyDialogsOverlay({
    super.initialEntries = const <OverlayEntry>[],
    super.clipBehavior = Clip.hardEdge,
    super.key,
  });

  @override
  EasyDialogsOverlayState createState() => EasyDialogsOverlayState();
}

final class EasyDialogsOverlayState extends OverlayState
    implements IEasyOverlay {
  @visibleForTesting
  final box = EasyDialogsOverlayBox();

  late final controller = EasyDialogsController(this);

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
  void dispose() {
    controller.dispose();
    super.dispose();
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
  void insertDialog(EasyOverlayBoxInsertion<EasyDialog> insertion) =>
      insert(insertion(box));

  @override
  void removeDialog(EasyOverlayBoxRemoval<EasyDialog> removal) =>
      removal(box)?.remove();
}

/// App overlay entry.
final class EasyOverlayAppEntry extends EasyOverlayEntry {
  /// Creates an instance of [EasyOverlayAppEntry].
  EasyOverlayAppEntry({required super.builder});
}
