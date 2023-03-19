import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dismissible.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_scope.dart';

part 'gesture.dart';
part 'none.dart';

abstract class EasyFullScreenDismissible extends EasyDismissible {
  const EasyFullScreenDismissible({required super.onDismiss});

  const factory EasyFullScreenDismissible.gesture({
    OnEasyDismiss? onDismiss,
  }) = _Gesture;

  const factory EasyFullScreenDismissible.none() = _None;
}
