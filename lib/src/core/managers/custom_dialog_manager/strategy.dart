import 'package:flutter/widgets.dart';

import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';

class CustomEntriesAccessor {
  const CustomEntriesAccessor._();

  @visibleForTesting
  static const key = 'custom';

  /// If entry key is `null` - creates new
  @visibleForTesting
  static List<OverlayEntry> createIfNullAndGet(EasyOverlayState overlayState) =>
      (overlayState.putIfAbsent(key, () => <OverlayEntry>[]));

  /// Access custom dialogs entries
  @visibleForTesting
  static List<OverlayEntry> get(EasyOverlayState overlayState) {
    final container = overlayState[key];
    assert(container != null, 'entries container is not initialized');

    return overlayState[key]! as List<OverlayEntry>;
  }
}

/// Insert custom dialog
///
/// returns dialogId [_onInserted] of inserted [dialog]
class CustomDialogInsertStrategy extends EasyOverlayInsertStrategy {
  final Function(int dialogId)? _onInserted;

  const CustomDialogInsertStrategy({
    required super.dialog,
    Function(int dialogId)? onInserted,
  }) : _onInserted = onInserted;

  @override
  void apply(EasyOverlayState overlayState) {
    final container = CustomEntriesAccessor.createIfNullAndGet(overlayState);

    final entry = OverlayEntry(builder: (_) => dialog);

    container.add(entry);

    overlayState.insert(entry);

    final dialogId = container.indexOf(entry);

    _onInserted?.call(dialogId);
  }
}

class CustomDialogRemoveStrategy extends EasyOverlayRemoveStrategy {
  /// Identifier of dialog that should be removed
  final int _dialogId;

  const CustomDialogRemoveStrategy({
    required int dialogId,
  }) : _dialogId = dialogId;

  @override
  void apply(EasyOverlayState overlayState) {
    final container = CustomEntriesAccessor.get(overlayState);

    final entry =
        ((_dialogId < container.length) ? container[_dialogId] : null);

    if (entry == null) return;

    container.removeAt(_dialogId);
    entry.remove();
  }
}
