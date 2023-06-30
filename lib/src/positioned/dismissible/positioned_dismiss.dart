import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'animated_tap.dart';
part 'swipe.dart';
part 'tap.dart';

/// Dismissible that is used by [PositionedConversation].
abstract base class PositionedDismiss<T>
    extends EasyDialogDismiss<PositionedDialog, T> {
  const PositionedDismiss({
    super.onDismissed,
    super.willDismiss,
  });

  /// Simple tap gesture dismissible.
  const factory PositionedDismiss.tap({
    HitTestBehavior? behavior,
    OnEasyDismissed<T>? onDismissed,
    EasyWillDismiss? willDismiss,
  }) = _Tap<T>;

  /// Tap gesture but with extra `scale in` on tap down animation.
  const factory PositionedDismiss.animatedTap({
    Duration duration,
    OnEasyDismissed<T>? onDismissed,
    EasyWillDismiss? willDismiss,
  }) = _AnimatedTap<T>;

  /// Horizontal swipe dismissible.
  ///
  /// Simply uses [Dismissible] under the hood.
  const factory PositionedDismiss.swipe({
    PositionedDismissibleSwipeDirection direction,
    OnEasyDismissed<T>? onDismissed,
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
  }) = _Swipe<T>;
}
