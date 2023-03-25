import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_easy_dialogs/src/custom/manager/custom_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';

/// Implementation of inserting into [IEasyDialogsOverlayBox]
/// specific to [CustomDialogManager].

// Just a complex file
// ignore: prefer-match-file-name
class CustomDialogInsertStrategy
    extends EasyOverlayBoxInsert<CustomDialogManager> {
  /// Callback that is fired upon inserting a dialog
  /// into [IEasyDialogsOverlayBox].
  ///
  /// Provides an identifier for the inserted dialog, which can be used for
  /// removing it in the future.
  final Function(int dialogId)? _onInserted;

  const CustomDialogInsertStrategy({
    required super.dialog,
    Function(int dialogId)? onInserted,
  }) : _onInserted = onInserted;

  @override
  EasyOverlayEntry apply(IEasyDialogsOverlayBox box) {
    final container = box.putIfAbsent<List<EasyOverlayEntry>>(key, () => []);

    final entry = EasyDialogsOverlayEntry(builder: (_) => dialog);

    container.add(entry);

    final dialogId = container.indexOf(entry);

    _onInserted?.call(dialogId);

    return entry;
  }
}

/// Implementation of remove strategy specific to the [CustomDialogManager].
class CustomDialogRemoveStrategy
    extends EasyOverlayBoxRemove<CustomDialogManager> {
  /// Identifier of dialog that should be removed.
  final int _dialogId;

  /// @nodoc
  const CustomDialogRemoveStrategy({required int dialogId})
      : _dialogId = dialogId;

  @override
  EasyOverlayEntry? apply(IEasyDialogsOverlayBox box) {
    final container = box.get<List<EasyOverlayEntry>>(key);

    assert(container != null, 'container of entries is not initialized');

    final entry =
        ((_dialogId < container!.length) ? container[_dialogId] : null);

    if (entry == null) return null;

    container.removeAt(_dialogId);

    return entry;
  }
}
