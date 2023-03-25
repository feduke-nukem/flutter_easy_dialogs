import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';

part 'gesture.dart';
part 'none.dart';

/// This is an implementation of [EasyDialogDismissible] that is specific to
/// [FullScreenDialogManager].
///
/// It is responsible for providing the dismissible behavior to
/// the provided dialog content using [onDismissed] callback.
abstract class FullScreenDismissible extends EasyDialogDismissible {
  const FullScreenDismissible({required super.onDismissed});

  /// Simple gesture tap dismiss.
  const factory FullScreenDismissible.gesture({
    HitTestBehavior behavior,
    OnEasyDismissed? onDismissed,
  }) = _Gesture;

  const factory FullScreenDismissible.none() = _None;
}
