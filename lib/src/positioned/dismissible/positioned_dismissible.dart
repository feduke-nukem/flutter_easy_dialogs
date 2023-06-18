import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/positioned/dialog/positioned_dialog_conversation.dart';
import 'package:flutter_easy_dialogs/src/positioned/easy_dialog_position.dart';

part 'animated_tap.dart';
part 'swipe.dart';
part 'tap.dart';
part 'none.dart';

/// Dismissible that is used by [PositionedConversation].
abstract base class PositionedDismissible extends EasyDialogDismissible {
  const PositionedDismissible({required super.onDismissed});

  /// Simple tap gesture dismissible.
  const factory PositionedDismissible.tap({
    HitTestBehavior? behavior,
    OnEasyDismissed? onDismissed,
  }) = _Tap;

  /// Tap gesture but with extra `scale in` on tap down animation.
  const factory PositionedDismissible.animatedTap({
    Duration duration,
    OnEasyDismissed? onDismissed,
  }) = _AnimatedTap;

  /// Horizontal swipe dismissible.
  ///
  /// Simply uses [Dismissible] under the hood.
  const factory PositionedDismissible.swipe({
    PositionedDismissibleSwipeDirection direction,
    OnEasyDismissed? onDismissed,
    Widget? background,
    Widget? secondaryBackground,
    ConfirmDismissCallback? confirmDismiss,
    VoidCallback? onResize,
    Duration? resizeDuration,
    Map<DismissDirection, double> dismissThresholds,
    Duration movementDuration,
    double crossAxisEndOffset,
    DragStartBehavior dragStartBehavior,
    HitTestBehavior behavior,
    DismissUpdateCallback? onUpdate,
  }) = _Swipe;

  /// No dismissible behavior will be added.
  const factory PositionedDismissible.none() = _None;
}
