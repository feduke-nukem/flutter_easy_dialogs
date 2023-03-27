part of 'positioned_dialog_manager.dart';

/// Insert positioned dialog into [IEasyDialogsOverlayBox].
///
/// Only single one dialog of concrete position can persists at the same time.

// Just a complex file
// ignore: prefer-match-file-name
class PositionedDialogInsertStrategy
    extends EasyOverlayBoxInsert<PositionedDialogManager> {
  final EasyDialogPosition position;

  const PositionedDialogInsertStrategy({
    required this.position,
    required super.dialog,
  });

  @override
  EasyOverlayEntry apply(IEasyDialogsOverlayBox box) {
    final container =
        box.putIfAbsent<Map<EasyDialogPosition, EasyOverlayEntry>>(
      key,
      () => {},
    );
    assert(
      !container.containsKey(position),
      'only single one $EasyDialogsOverlayEntry with the same $EasyDialogPosition can be presented at the same time',
    );

    final entry = EasyDialogsOverlayEntry(
      builder: (_) => dialog,
    );

    container[position] = entry;

    return entry;
  }
}

/// Remove positioned dialog from the [IEasyDialogsOverlayBox].
class PositionedDialogRemoveStrategy
    extends EasyOverlayBoxRemove<PositionedDialogManager> {
  final EasyDialogPosition position;

  const PositionedDialogRemoveStrategy({
    required this.position,
  });

  @override
  EasyOverlayEntry? apply(IEasyDialogsOverlayBox box) {
    final container = box.get<Map<EasyDialogPosition, EasyOverlayEntry>>(key);

    assert(container != null, 'entries container is not initialized');

    if (container!.entries.isEmpty) return null;

    return container.remove(position);
  }
}
