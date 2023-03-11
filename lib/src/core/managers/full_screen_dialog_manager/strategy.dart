part of 'full_screen_dialog_manager.dart';

class FullScreenDialogEntriesAccessor {
  const FullScreenDialogEntriesAccessor._();

  @visibleForTesting
  static const key = 'fullScreen';
}

/// Strategy for inserting `full screen dialogs`
class FullScreenDialogInsertStrategy extends EasyOverlayInsertStrategy {
  const FullScreenDialogInsertStrategy({required super.dialog});

  @override
  void apply(EasyOverlayState overlayState) {
    assert(
      overlayState[FullScreenDialogEntriesAccessor.key] == null,
      'only single one full screen $EasyOverlayEntry can be presented',
    );

    final entry = EasyOverlayEntry(
      builder: (_) => dialog,
    );

    overlayState
      ..insert(entry)
      ..[FullScreenDialogEntriesAccessor.key] = entry;
  }
}

/// Remove full screen dialog from overlay
@visibleForTesting
class FullScreenDialogRemoveStrategy extends EasyOverlayRemoveStrategy {
  const FullScreenDialogRemoveStrategy();

  @override
  void apply(EasyOverlayState overlayState) {
    (overlayState[FullScreenDialogEntriesAccessor.key]! as OverlayEntry)
        .remove();
    overlayState[FullScreenDialogEntriesAccessor.key] = null;
  }
}
