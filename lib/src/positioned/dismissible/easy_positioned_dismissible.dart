import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dismissible.dart';
import 'package:flutter_easy_dialogs/src/positioned/deprecated/easy_positioned_dismissible_type.dart';
import 'package:flutter_easy_dialogs/src/util/easy_dialog_scope_x.dart';

part 'tap.dart';
part 'swipe.dart';
part 'gesture.dart';

abstract class EasyPositionedDismissible extends EasyDismissible {
  const EasyPositionedDismissible({required super.onDismiss});

  const factory EasyPositionedDismissible.gesture({
    OnEasyDismiss? onDismiss,
  }) = _Gesture;

  const factory EasyPositionedDismissible.tap({
    OnEasyDismiss? onDismiss,
  }) = _Tap;

  const factory EasyPositionedDismissible.swipe({
    OnEasyDismiss? onDismiss,
  }) = _Swipe;

  /// Should be removed after removing deprecated API.
  factory EasyPositionedDismissible.fromType({
    required EasyPositionedDismissibleType type,
    OnEasyDismiss? onDismiss,
  }) {
    switch (type) {
      case EasyPositionedDismissibleType.none:
        return EasyPositionedDismissible.gesture();

      case EasyPositionedDismissibleType.swipe:
        return EasyPositionedDismissible.swipe(onDismiss: onDismiss);

      case EasyPositionedDismissibleType.tap:
        return EasyPositionedDismissible.tap(onDismiss: onDismiss);
    }
  }
}
