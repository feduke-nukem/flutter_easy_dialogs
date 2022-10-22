import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';

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
  final _entriesMap = <EasyDialogType, List<OverlayEntry>>{};

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

  void removeEntriesByType(EasyDialogType type) {
    final entries = _entriesMap[type];

    if (entries == null || entries.isEmpty) return;

    for (var entry in entries) {
      if (entry.mounted) entry.remove();
    }

    _entriesMap.remove(type);
  }

  void _handleNewEntry(OverlayEntry entry) {
    final type =
        (entry is EasyDialogsOverlayEntry) ? entry.type : EasyDialogType.other;

    final list = _entriesMap[type];

    if (type == EasyDialogType.main) {
      assert(list == null,
          'Only one main $EasyDialogsOverlay can be presented at the same time');
    }

    list == null ? _entriesMap[type] = <OverlayEntry>[entry] : list.add(entry);
  }
}

class EasyDialogsOverlayEntry extends OverlayEntry {
  /// Dialog type
  final EasyDialogType type;

  EasyDialogsOverlayEntry({
    required this.type,
    required super.builder,
  });

  @override
  void markNeedsBuild() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        super.markNeedsBuild();
      });

      return;
    }

    super.markNeedsBuild();
  }
}
