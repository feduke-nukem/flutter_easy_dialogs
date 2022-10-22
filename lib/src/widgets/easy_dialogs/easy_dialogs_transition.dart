import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_animation.dart';

/// Transition for [EasyDialogsAnimation]
class EasyDialogsTransition extends AnimatedWidget {
  final Widget child;

  /// Creates instance of [EasyDialogsTransition]
  const EasyDialogsTransition({
    required this.child,
    required EasyDialogsAnimation animation,
    super.key,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as EasyDialogsAnimation;

    return animation.map(
      slide: (slide) => SlideTransition(
        position: slide.animation,
        child: child,
      ),
      fade: (fade) => FadeTransition(
        opacity: fade.animation,
        child: child,
      ),
    );
  }
}
