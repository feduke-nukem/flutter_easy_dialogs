import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';
import 'package:flutter_easy_dialogs/src/positioned/manager/positioned_dialog_manager.dart';

part 'tap.dart';
part 'horizontal_swipe.dart';
part 'gesture.dart';
part 'none.dart';

/// Dismissible that is used by [PositionedDialogManager].
abstract class PositionedDismissible extends EasyDialogDismissible {
  const PositionedDismissible({required super.onDismissed});

  /// Simple tap gesture dismissible.
  const factory PositionedDismissible.gesture({
    OnEasyDismissed? onDismissed,
  }) = _Gesture;

  /// Tap gesture but with extra `scale in` on tap down animation.
  const factory PositionedDismissible.tap({
    OnEasyDismissed? onDismissed,
  }) = _Tap;

  /// Horizontal swipe dismissible.
  ///
  /// Simply uses [Dismissible] under the hood.
  const factory PositionedDismissible.horizontalSwipe({
    OnEasyDismissed? onDismissed,
  }) = _HorizontalSwipe;

  /// No dismissible behavior will be added.
  const factory PositionedDismissible.none() = _None;
}
