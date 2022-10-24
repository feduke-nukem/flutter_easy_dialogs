import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_position.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs_exception.dart';

class EasyDialogsFadeAnimation extends EasyDialogsAnimation {
  final EasyDialogsPosition position;

  EasyDialogsFadeAnimation({
    required super.data,
    required this.position,
  });

  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    final animation = FadeTransition(
      opacity: parent,
      child: child,
    );

    return Align(
      alignment: _aligment,
      child: animation,
    );
  }

  Alignment get _aligment {
    switch (position) {
      case EasyDialogsPosition.top:
        return Alignment.topCenter;

      case EasyDialogsPosition.bottom:
        return Alignment.bottomCenter;

      case EasyDialogsPosition.center:
        return Alignment.center;
      default:
        Error.throwWithStackTrace(
          FlutterEasyDialogsError(message: 'no case for $position'),
          StackTrace.current,
        );
    }
  }
}
