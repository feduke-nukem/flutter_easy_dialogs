import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'swipe.dart';

/// Dismissible that is used by [PositionedDialog].
abstract base class PositionedDismiss
    extends EasyDialogDismiss<PositionedDialog> {
  const PositionedDismiss({
    super.onDismissed,
    super.willDismiss,
  });

  /// Horizontal swipe dismissible.
  ///
  /// Simply uses [Dismissible] under the hood.
  const factory PositionedDismiss.swipe({
    PositionedDismissibleSwipeDirection direction,
    OnEasyDismissed? onDismissed,
    Widget? background,
    Widget? secondaryBackground,
    VoidCallback? onResize,
    Duration? resizeDuration,
    Map<DismissDirection, double> dismissThresholds,
    Duration movementDuration,
    double crossAxisEndOffset,
    DragStartBehavior dragStartBehavior,
    HitTestBehavior behavior,
    DismissUpdateCallback? onUpdate,
    EasyWillDismiss? willDismiss,
  }) = _Swipe;
}
