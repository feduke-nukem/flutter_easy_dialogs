import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_easy_dialogs/src/custom/manager/custom_manager.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';

/// Insert custom dialog
/// returns dialogId [_onInserted] of inserted [dialog].

// Just a complex file
// ignore: prefer-match-file-name
class CustomDialogInsertStrategy extends EasyOverlayBoxInsert<CustomManager> {
  final Function(int dialogId)? _onInserted;

  const CustomDialogInsertStrategy({
    required super.dialog,
    Function(int dialogId)? onInserted,
  }) : _onInserted = onInserted;

  @override
  EasyOverlayEntry apply(IEasyOverlayBox box) {
    final container = box.putIfAbsent<List<EasyOverlayEntry>>(key, () => []);

    final entry = EasyDialogsOverlayEntry(builder: (_) => dialog);

    container.add(entry);

    final dialogId = container.indexOf(entry);

    _onInserted?.call(dialogId);

    return entry;
  }
}

class CustomDialogRemoveStrategy extends EasyOverlayBoxRemove<CustomManager> {
  /// Identifier of dialog that should be removed.
  final int _dialogId;

  const CustomDialogRemoveStrategy({
    required int dialogId,
  }) : _dialogId = dialogId;

  @override
  EasyOverlayEntry? apply(IEasyOverlayBox box) {
    final container = box.get<List<EasyOverlayEntry>>(key);

    assert(container != null, 'entries container is not initialized');

    final entry =
        ((_dialogId < container!.length) ? container[_dialogId] : null);

    if (entry == null) return null;

    container.removeAt(_dialogId);

    return entry;
  }
}
