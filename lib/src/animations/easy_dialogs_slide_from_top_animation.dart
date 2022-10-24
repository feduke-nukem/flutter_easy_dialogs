import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation.dart';

class EasyDialogsSlideFromTopAnimation extends EasyDialogsAnimation {
  EasyDialogsSlideFromTopAnimation({
    required super.curve,
    required super.duration,
    required super.reverseDuration,
  });

  final _tween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: const Offset(0.0, 0.0),
  );

  @override
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  }) {
    return SlideTransition(
      position: _tween.animate(parent),
      child: Align(
        alignment: Alignment.topCenter,
        child: child,
      ),
    );
  }
}
