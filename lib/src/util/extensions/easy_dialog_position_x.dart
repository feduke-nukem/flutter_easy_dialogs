import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs_error.dart';

/// Extension for [EasyDialogPosition]
extension EasyDialogPositionX on EasyDialogPosition {
  /// Convert [EasyDialogPosition] to [Alignment]
  Alignment toAlignment() {
    switch (this) {
      case EasyDialogPosition.top:
        return Alignment.topCenter;

      case EasyDialogPosition.bottom:
        return Alignment.bottomCenter;

      case EasyDialogPosition.center:
        return Alignment.center;
      default:
        Error.throwWithStackTrace(
          FlutterEasyDialogsError(message: 'no case for $this'),
          StackTrace.current,
        );
    }
  }
}
