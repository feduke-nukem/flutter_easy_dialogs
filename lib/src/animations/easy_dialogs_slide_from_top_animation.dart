import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation.dart';

class EasyDialogsSlideFromTopAnimation extends EasyDialogsAnimation {
  EasyDialogsSlideFromTopAnimation({
    required super.data,
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
    return Align(
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: _tween.animate(parent),
        child: child,
      ),
    );
  }
}
