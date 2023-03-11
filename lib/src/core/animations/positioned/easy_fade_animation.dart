import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/util/extensions/easy_dialog_position_x.dart';

/// Fade animation
class EasyFadeAnimation extends EasyAnimation {
  final _tween = Tween<double>(begin: 0.0, end: 1.0);
  final EasyDialogPosition position;

  EasyFadeAnimation({
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
      alignment: position.toAlignment(),
      child: transition,
    );
  }
}
