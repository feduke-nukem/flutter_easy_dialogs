import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation.dart';

class EasyDialogsSlideFromTopAnimation extends EasyDialogsAnimation {
  EasyDialogsSlideFromTopAnimation({
    required super.settings,
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

    // return Align(
    //   alignment: Alignment.bottomCenter,
    //   child: SlideTrans(
    //     listenable: _tweenD.animate(parent),
    //     child: child,
    //   ),
    // );
  }
}

/// TODO: Make usage of this
class SlideTrans extends AnimatedWidget {
  final Widget child;
  const SlideTrans({
    required this.child,
    required super.listenable,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final animation = (super.listenable as Animation<double>);

    return ClipRect(
      child: Align(
        heightFactor: animation.value,
        child: child,
      ),
    );
  }
}
