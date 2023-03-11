// ignore_for_file: library_private_types_in_public_api

part of 'easy_overlay.dart';

/// Insert strategy
abstract class EasyOverlayInsertStrategy {
  final Widget dialog;

  const EasyOverlayInsertStrategy({
    required this.dialog,
  });

  factory EasyOverlayInsertStrategy.positioned({
    required EasyDialogPosition position,
    required Widget dialog,
  }) = _PositionedDialogInsertStrategy;

  factory EasyOverlayInsertStrategy.fullScreen({
    required Widget dialog,
  }) = _FullScreenDialogInsertStrategy;

  factory EasyOverlayInsertStrategy.custom({
    required Widget dialog,
    Function(int dialogId)? onInserted,
  }) = _CustomDialogInsertStrategy;

  /// Apply strategy to provided [overlayState]
  void apply(EasyOverlayState overlayState);
}

/// Insert positioned dialog into overlay
///
/// Only single one dialog of concrete position can persists at the same time
class _PositionedDialogInsertStrategy extends EasyOverlayInsertStrategy {
  final EasyDialogPosition position;

  _PositionedDialogInsertStrategy({
    required this.position,
    required super.dialog,
  });

  @override
  void apply(EasyOverlayState overlayState) {
    final container = EasyOverlayEntriesInsertAccessor.positioned(
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

/// Strategy for inserting `full screen dialogs`
class _FullScreenDialogInsertStrategy extends EasyOverlayInsertStrategy {
  _FullScreenDialogInsertStrategy({required super.dialog});

  @override
  void apply(EasyOverlayState overlayState) {
    assert(
      overlayState.currentEntries[EasyOverlayEntriesAccessKeys.fullScreen] ==
          null,
      'only single one full screen $EasyOverlayEntry can be presented',
    );

    final entry = EasyOverlayEntry(
      builder: (_) => dialog,
    );

    overlayState
      ..insert(entry)
      ..currentEntries[EasyOverlayEntriesAccessKeys.fullScreen] = entry;
  }
}

/// Insert custom dialog
///
/// returns dialogId [_onInserted] of inserted [dialog]
class _CustomDialogInsertStrategy extends EasyOverlayInsertStrategy {
  final Function(int dialogId)? _onInserted;

  _CustomDialogInsertStrategy({
    required super.dialog,
    Function(int dialogId)? onInserted,
  }) : _onInserted = onInserted;

  @override
  void apply(EasyOverlayState overlayState) {
    final container = EasyOverlayEntriesInsertAccessor.custom(overlayState);

    final entry = OverlayEntry(builder: (_) => dialog);

    container.add(entry);

    overlayState.insert(entry);

    final dialogId = container.indexOf(entry);

    _onInserted?.call(dialogId);
  }
}
