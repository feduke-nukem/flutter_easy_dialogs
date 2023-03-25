part of 'full_screen_dialog_manager.dart';

/// Strategy for inserting `full screen dialogs`.
///
// Complex helper file, name independent
// ignore:prefer-match-file-name
class FullScreenDialogInsertStrategy
    extends EasyOverlayBoxInsert<FullScreenDialogManager> {
  /// @nodoc
  const FullScreenDialogInsertStrategy({required super.dialog});

  @override
  EasyOverlayEntry apply(IEasyDialogsOverlayBox box) {
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

/// This is an implementation of the removing strategy for full-screen dialogs
/// from the [IEasyDialogsOverlayBox].
@visibleForTesting
class FullScreenDialogRemoveStrategy
    extends EasyOverlayBoxRemove<FullScreenDialogManager> {
  /// Creates a new instance of the [FullScreenDialogRemoveStrategy].
  const FullScreenDialogRemoveStrategy();

  @override
  EasyOverlayEntry? apply(IEasyDialogsOverlayBox box) =>
      box.remove<EasyOverlayEntry>(key);
}
