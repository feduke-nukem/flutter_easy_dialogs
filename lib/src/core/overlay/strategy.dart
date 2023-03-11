part of 'easy_overlay.dart';

/// Insert strategy
abstract class EasyOverlayInsertStrategy {
  final Widget dialog;

  const EasyOverlayInsertStrategy({
    required this.dialog,
  });

  /// Apply strategy to provided [overlayState]
  void apply(EasyOverlayState overlayState);
}

/// Remove strategy
abstract class EasyOverlayRemoveStrategy {
  const EasyOverlayRemoveStrategy();

  /// Apply strategy to provided [overlayState]
  void apply(EasyOverlayState overlayState);
}
