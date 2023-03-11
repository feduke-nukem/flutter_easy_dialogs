part of 'easy_overlay.dart';

/// Keys to access [Map] entries inside [EasyOverlayState.currentEntries]
class EasyOverlayEntriesAccessKeys {
  const EasyOverlayEntriesAccessKeys._();

  /// For positioned dialogs
  static const positioned = 'positioned';

  /// For full screen dialogs
  static const fullScreen = 'fullScreen';

  /// For custom dialogs
  static const custom = 'custom';
}

/// Helper for accessing entries using [EasyOverlayInsertStrategy]
class EasyOverlayEntriesInsertAccessor {
  const EasyOverlayEntriesInsertAccessor._();

  /// If entry key is `null` - creates new
  ///
  /// Is created for using within [_PositionedDialogInsertStrategy]
  static Map<EasyDialogPosition, OverlayEntry> positioned(
    EasyOverlayState overlayState,
  ) =>
      (overlayState.currentEntries[EasyOverlayEntriesAccessKeys.positioned] ??=
              <EasyDialogPosition, OverlayEntry>{})
          as Map<EasyDialogPosition, OverlayEntry>;

  /// If entry key is `null` - creates new
  ///
  /// Is created for using within [_CustomDialogInsertStrategy]
  static List<OverlayEntry> custom(EasyOverlayState overlayState) =>
      (overlayState.currentEntries[EasyOverlayEntriesAccessKeys.custom] ??=
          <OverlayEntry>[]) as List<OverlayEntry>;
}

/// Helper for accessing entries
class EasyOverlayEntriesRawAccessor {
  const EasyOverlayEntriesRawAccessor._();

  /// Access positioned dialogs entries
  static Map<EasyDialogPosition, OverlayEntry> positioned(
    EasyOverlayState overlayState,
  ) {
    final container =
        overlayState.currentEntries[EasyOverlayEntriesAccessKeys.positioned];

    assert(container != null, 'entries container is not initialized');

    return overlayState.currentEntries[EasyOverlayEntriesAccessKeys.positioned]!
        as Map<EasyDialogPosition, OverlayEntry>;
  }

  /// Access custom dialogs entries
  static List<OverlayEntry> custom(EasyOverlayState overlayState) {
    final container =
        overlayState.currentEntries[EasyOverlayEntriesAccessKeys.custom];
    assert(container != null, 'entries container is not initialized');

    return overlayState.currentEntries[EasyOverlayEntriesAccessKeys.custom]!
        as List<OverlayEntry>;
  }
}
