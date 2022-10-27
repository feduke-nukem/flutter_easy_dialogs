import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs_exception.dart';

extension EasyDialogPositionX on EasyDialogPosition {
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
