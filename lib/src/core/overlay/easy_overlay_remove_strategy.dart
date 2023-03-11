// ignore_for_file: library_private_types_in_public_api

part of 'easy_overlay.dart';

/// Remove strategy
abstract class EasyOverlayRemoveStrategy {
  const EasyOverlayRemoveStrategy();

  factory EasyOverlayRemoveStrategy.positioned({
    required EasyDialogPosition position,
  }) = _PositionedDialogRemoveStrategy;

  factory EasyOverlayRemoveStrategy.fullScreen() =
      _FullScreenDialogRemoveStrategy;

  factory EasyOverlayRemoveStrategy.custom({required int dialogId}) =
      _CustomDialogRemoveStrategy;

  /// Apply strategy to provided [overlayState]
  void apply(EasyOverlayState overlayState);
}

/// Remove positioned dialog from overlay
class _PositionedDialogRemoveStrategy extends EasyOverlayRemoveStrategy {
  final EasyDialogPosition position;

  _PositionedDialogRemoveStrategy({
    required this.position,
  });

  @override
  void apply(EasyOverlayState overlayState) {
    final container = EasyOverlayEntriesRawAccessor.positioned(overlayState);

    if (container.entries.isEmpty) return;

    final entry = container.remove(position);

    if (entry == null) return;

    entry.remove();
  }
}

/// Remove full screen dialog from overlay
class _FullScreenDialogRemoveStrategy extends EasyOverlayRemoveStrategy {
  @override
  void apply(EasyOverlayState overlayState) {
    (overlayState.currentEntries[EasyOverlayEntriesAccessKeys.fullScreen]!
            as OverlayEntry)
        .remove();
    overlayState.currentEntries[EasyOverlayEntriesAccessKeys.fullScreen] = null;
  }
}

class _CustomDialogRemoveStrategy extends EasyOverlayRemoveStrategy {
  /// Identifier of dialog that should be removed
  final int _dialogId;

  const _CustomDialogRemoveStrategy({
    required int dialogId,
  }) : _dialogId = dialogId;

  @override
  void apply(EasyOverlayState overlayState) {
    final container = EasyOverlayEntriesRawAccessor.custom(overlayState);

    final entry =
        ((_dialogId < container.length) ? container[_dialogId] : null);

    if (entry == null) return;

    container.removeAt(_dialogId);
    entry.remove();
  }
}
