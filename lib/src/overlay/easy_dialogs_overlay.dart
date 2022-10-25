import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_orverlay_entry_properties.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_dialog.dart';

class EasyDialogsOverlay extends Overlay {
  const EasyDialogsOverlay({
    super.initialEntries = const <OverlayEntry>[],
    super.clipBehavior = Clip.hardEdge,
    super.key,
  });

  @override
  OverlayState createState() => EasyDialogsOverlayState();
}

class EasyDialogsOverlayState extends OverlayState
    implements IEasyDialogsOverlayController {
  final _entriesMap = <EasyDialogOverlayEntryProperties, OverlayEntry>{};

  @override
  EasyDialogsOverlayEntry insertDialog({
    required EasyDialogBase child,
    required EasyDialogPosition position,
    required EasyDialogType type,
  }) {
    final props = EasyDialogOverlayEntryProperties(
      dialogPosition: position,
      dialogType: type,
    );

    final entry = EasyDialogsOverlayEntry(
      properties: props,
      builder: (_) => child,
    );

    insert(entry);

    return entry;
  }

  @override
  void insert(OverlayEntry entry, {OverlayEntry? below, OverlayEntry? above}) {
    super.insert(entry, below: below, above: above);
    _handleNewEntry(entry);

    if (below != null) _handleNewEntry(below);
    if (above != null) _handleNewEntry(above);
  }

  @override
  void insertAll(Iterable<OverlayEntry> entries,
      {OverlayEntry? below, OverlayEntry? above}) {
    super.insertAll(entries, below: below, above: above);

    entries.forEach(_handleNewEntry);

    if (below != null) _handleNewEntry(below);
    if (above != null) _handleNewEntry(above);
  }

  @override
  void removeDialogByTypeAndPosition({
    required EasyDialogType type,
    required EasyDialogPosition position,
  }) {
    if (_entriesMap.entries.isEmpty) return;

    _entriesMap.remove(
      EasyDialogOverlayEntryProperties(
        dialogPosition: position,
        dialogType: type,
      ),
    );
  }

  void removeEntriesByType(EasyDialogType type) {
    if (_entriesMap.entries.isEmpty) return;

    for (final entry in _entriesMap.entries) {
      final shouldRemove = entry.key.dialogType == type && entry.value.mounted;

      if (!shouldRemove) continue;

      entry.value.remove();
      _entriesMap.remove(entry.key);
    }
  }

  void removeEntriesByPosition(EasyDialogPosition position) {
    if (_entriesMap.entries.isEmpty) return;

    for (final entry in _entriesMap.entries) {
      final shouldRemove =
          entry.key.dialogPosition == position && entry.value.mounted;

      if (!shouldRemove) continue;

      entry.value.remove();
      _entriesMap.remove(entry.key);
    }
  }

  void _handleNewEntry(OverlayEntry entry) {
    final newOverlayEntryProps = (entry is EasyDialogsOverlayEntry)
        ? entry.properties
        : EasyDialogOverlayEntryProperties.other();

    if (newOverlayEntryProps.dialogType == EasyDialogType.app) {
      assert(
          !_entriesMap.keys
              .any((element) => element.dialogType == EasyDialogType.app),
          'Only one app $EasyDialogsOverlay can be presented at the same time');
    }

    assert(
      !_entriesMap.keys.contains(newOverlayEntryProps),
      'only single one $EasyDialogType with the same $EasyDialogPosition can be presented at the same time',
    );

    assert(
      !_entriesMap.keys
          .any((element) => element.dialogType == EasyDialogPosition.other),
      'Only single one $EasyDialogType of "other" can be presented at the same time',
    );

    _entriesMap[newOverlayEntryProps] = entry;
  }
}

/// Interface for manipulating overlay with dialogs
abstract class IEasyDialogsOverlayController {
  EasyDialogsOverlayEntry insertDialog({
    required EasyDialogBase child,
    required EasyDialogPosition position,
    required EasyDialogType type,
  });

  void removeDialogByTypeAndPosition({
    required EasyDialogType type,
    required EasyDialogPosition position,
  });
}
