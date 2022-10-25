import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_position.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs_exception.dart';

class EasyDialogsFadeAnimation extends EasyDialogsAnimation {
  final _tween = Tween<double>(begin: 0.0, end: 1.0);
  final EasyDialogPosition position;

  EasyDialogsFadeAnimation({
    required this.position,
    required super.curve,
  });

  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    final transition = FadeTransition(
      opacity: curve != null
          ? parent.drive(
              _tween.chain(
                CurveTween(curve: curve!),
              ),
            )
          : _tween.animate(parent),
      child: child,
    );

    return Align(
      alignment: _aligment,
      child: transition,
    );
  }

  Alignment get _aligment {
    switch (position) {
      case EasyDialogPosition.top:
        return Alignment.topCenter;

      case EasyDialogPosition.bottom:
        return Alignment.bottomCenter;

      case EasyDialogPosition.center:
        return Alignment.center;
      default:
        Error.throwWithStackTrace(
          FlutterEasyDialogsError(message: 'no case for $position'),
          StackTrace.current,
        );
    }
  }
}
