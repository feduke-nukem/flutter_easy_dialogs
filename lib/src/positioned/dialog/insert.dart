part of 'positioned_dialog_conversation.dart';

/// Insert positioned dialog into [IEasyDialogsOverlayBox].
///
/// Only single one dialog of concrete position can persists at the same time.

// Just a complex file
// ignore: prefer-match-file-name
final class PositionedDialogInsert
    extends EasyOverlayBoxInsert<PositionedDialog> {
  const PositionedDialogInsert({
    required this.position,
    required super.dialog,
  });

  final EasyDialogPosition position;

  @override
  EasyOverlayEntry call(IEasyDialogsOverlayBox box) {
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
final class PositionedDialogRemove
    extends EasyOverlayBoxRemove<PositionedDialog> {
  final EasyDialogPosition position;

  const PositionedDialogRemove({
    required this.position,
  });

  @override
  EasyOverlayEntry? call(IEasyDialogsOverlayBox box) {
    final container = box.get<Map<EasyDialogPosition, EasyOverlayEntry>>(key);

    assert(container != null, 'entries container is not initialized');

    if (container!.entries.isEmpty) return null;

    return container.remove(position);
  }
}
