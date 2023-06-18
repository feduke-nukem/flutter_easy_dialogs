part of 'full_screen_dialog_conversation.dart';

/// Strategy for inserting `full screen dialogs`.
///
// Complex helper file, name independent
// ignore:prefer-match-file-name
final class FullScreenDialogInsert
    extends EasyOverlayBoxInsert<FullScreenDialog> {
  /// @nodoc
  const FullScreenDialogInsert({required super.dialog});

  @override
  EasyOverlayEntry call(IEasyDialogsOverlayBox box) {
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
final class FullScreenDialogRemove
    extends EasyOverlayBoxRemove<FullScreenDialog> {
  /// Creates a new instance of the [FullScreenDialogRemove].
  const FullScreenDialogRemove();

  @override
  EasyOverlayEntry? call(IEasyDialogsOverlayBox box) =>
      box.remove<EasyOverlayEntry>(key);
}
