import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_settings.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';

class EasyDialogsOverlay extends Overlay {
  const EasyDialogsOverlay({
    super.initialEntries = const <OverlayEntry>[],
    super.clipBehavior = Clip.hardEdge,
    super.key,
  });

  @override
  OverlayState createState() => EasyDialogsOverlayState();
}

class EasyDialogsOverlayState extends OverlayState {
  final _entriesMap = <EasyDialogSettings, OverlayEntry>{};

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

  void removeEntryByData(EasyDialogSettings data) {
    if (_entriesMap.entries.isEmpty) return;

    _entriesMap.remove(data);
  }

  void removeEntriesByType(EasyDialogType type) {
    if (_entriesMap.entries.isEmpty) return;

    for (final entry in _entriesMap.entries) {
      final shouldRemove = entry.key.type == type && entry.value.mounted;

      if (!shouldRemove) continue;

      entry.value.remove();
      _entriesMap.remove(entry.key);
    }
  }

  void removeEntriesByPosition(EasyDialogPosition position) {
    if (_entriesMap.entries.isEmpty) return;

    for (final entry in _entriesMap.entries) {
      final shouldRemove =
          entry.key.position == position && entry.value.mounted;

      if (!shouldRemove) continue;

      entry.value.remove();
      _entriesMap.remove(entry.key);
    }
  }

  void _handleNewEntry(OverlayEntry entry) {
    final newDialogData = (entry is EasyDialogsOverlayEntry)
        ? entry.dialogData
        : EasyDialogSettings.other();

    if (newDialogData.type == EasyDialogType.app) {
      assert(
          !_entriesMap.keys
              .any((element) => element.type == EasyDialogType.app),
          'Only one app $EasyDialogsOverlay can be presented at the same time');
    }

    assert(
      !_entriesMap.keys.contains(newDialogData),
      'only single one $EasyDialogType with the same $EasyDialogPosition can be presented at the same time',
    );

    assert(
      !_entriesMap.keys
          .any((element) => element.type == EasyDialogPosition.other),
      'Only single one $EasyDialogType of "other" can be presented at the same time',
    );

    _entriesMap[newDialogData] = entry;
  }
}
