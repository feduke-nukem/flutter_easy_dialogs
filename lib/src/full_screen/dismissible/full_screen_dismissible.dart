import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dialog/full_screen_dialog_conversation.dart';
part 'tap.dart';
part 'none.dart';

/// This is an implementation of [EasyDialogDismissible] that is specific to
/// [FullScreenDialogConversation].
///
/// It is responsible for providing the dismissible behavior to
/// the provided dialog content using [onDismissed] callback.
abstract base class FullScreenDismissible extends EasyDialogDismissible {
  const FullScreenDismissible({super.onDismissed});

  /// Simple gesture tap dismiss.
  const factory FullScreenDismissible.tap({
    HitTestBehavior behavior,
    OnEasyDismissed? onDismissed,
  }) = _Tap;

  const factory FullScreenDismissible.none() = _None;
}
