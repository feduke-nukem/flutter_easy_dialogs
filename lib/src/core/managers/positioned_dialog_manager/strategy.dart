part of 'positioned_dialog_manager.dart';

class PositionedDialogEntriesAccessor {
  const PositionedDialogEntriesAccessor._();

  @visibleForTesting
  static const key = 'positioned';

  /// Access positioned dialogs entries
  @visibleForTesting
  static Map<EasyDialogPosition, OverlayEntry> get(
    EasyOverlayState overlayState,
  ) {
    final container = overlayState[key];

    assert(container != null, 'entries container is not initialized');

    return overlayState[key]! as Map<EasyDialogPosition, OverlayEntry>;
  }

  /// If entry key is `null` - creates new
  @visibleForTesting
  static Map<EasyDialogPosition, OverlayEntry> createIfNullAndGet(
    EasyOverlayState overlayState,
  ) =>
      overlayState.putIfAbsent(key, () => <EasyDialogPosition, OverlayEntry>{});
}

/// Insert positioned dialog into overlay
///
/// Only single one dialog of concrete position can persists at the same time
class PositionedDialogInsertStrategy extends EasyOverlayInsertStrategy {
  final EasyDialogPosition position;

  const PositionedDialogInsertStrategy({
    required this.position,
    required super.dialog,
  });

  @override
  void apply(EasyOverlayState overlayState) {
    final container = PositionedDialogEntriesAccessor.createIfNullAndGet(
      overlayState,
    );

    assert(
      !container.containsKey(position),
      'only single one $EasyOverlayEntry with the same $EasyDialogPosition can be presented at the same time',
    );

    final entry = EasyOverlayEntry(
      builder: (_) => dialog,
    );

    container[position] = entry;

    overlayState.insert(entry);
  }
}

/// Remove positioned dialog from overlay
class PositionedDialogRemoveStrategy extends EasyOverlayRemoveStrategy {
  final EasyDialogPosition position;

  const PositionedDialogRemoveStrategy({
    required this.position,
  });

  @override
  void apply(EasyOverlayState overlayState) {
    final container = PositionedDialogEntriesAccessor.get(overlayState);

    if (container.entries.isEmpty) return;

    final entry = container.remove(position);

    if (entry == null) return;

    entry.remove();
  }
}
