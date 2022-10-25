import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation.dart';

class EasyDialogsSlideFromBotAnimation extends EasyDialogsAnimation {
  final _tween = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: const Offset(0.0, 0.0),
  );

  EasyDialogsSlideFromBotAnimation({
    super.curve,
  });

  @override
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  }) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: curve != null
            ? parent.drive(
                _tween.chain(
                  CurveTween(curve: curve!),
                ),
              )
            : _tween.animate(parent),
        child: child,
      ),
    );
  }
}
