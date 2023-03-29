import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';
import 'package:positioned_dialog_manager/src/manager/positioned_dialog_manager.dart';

part 'animated_tap.dart';
part 'swipe.dart';
part 'tap.dart';
part 'none.dart';

/// Dismissible that is used by [PositionedDialogManager].
abstract class PositionedDismissible extends EasyDialogDismissible<
    PositionedDismissibleData, EasyDismissiblePayload> {
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

/// Specific data for [PositionedDismissible]
class PositionedDismissibleData extends EasyDismissibleData {
  final EasyDialogPosition position;

  /// @nodoc
  const PositionedDismissibleData({
    required this.position,
    required super.dialog,
    super.dismissHandler,
  });
}
