import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
part 'tap.dart';

/// This is an implementation of [EasyDialogDismiss] that is specific to
/// [FullScreenDialog].
///
/// It is responsible for providing the dismissible behavior to
/// the provided dialog content using [onDismissed] callback.
abstract base class FullScreenDismiss
    extends EasyDialogDismiss<FullScreenDialog> {
  const FullScreenDismiss({
    super.onDismissed,
    super.willDismiss,
  });

  /// Simple gesture tap dismiss.
  const factory FullScreenDismiss.tap({
    HitTestBehavior behavior,
    OnEasyDismissed? onDismissed,
  }) = _Tap;
}
