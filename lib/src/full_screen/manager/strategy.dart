part of 'full_screen_manager.dart';

/// Strategy for inserting `full screen dialogs`.
///
// Complex helper file, name independent
// ignore:prefer-match-file-name
class FullScreenDialogInsertStrategy
    extends EasyOverlayBoxInsert<FullScreenManager> {
  const FullScreenDialogInsertStrategy({required super.dialog});

  @override
  EasyOverlayEntry apply(IEasyOverlayBox box) {
    assert(
      box.get(super.key) == null,
      'only single one full screen $EasyDialogsOverlayEntry can be presented',
    );

    final entry = EasyDialogsOverlayEntry(
      builder: (_) => dialog,
    );

    box.put(super.key, entry);

    return entry;
  }
}

/// Remove full screen dialog from the [IEasyOverlayBox].
@visibleForTesting
class FullScreenDialogRemoveStrategy
    extends EasyOverlayBoxRemove<FullScreenManager> {
  const FullScreenDialogRemoveStrategy();

  @override
  EasyOverlayEntry? apply(IEasyOverlayBox box) =>
      box.remove<EasyOverlayEntry>(key);
}
