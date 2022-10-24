import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation_settings.dart';

/// Base class of animation for EasyDialog
abstract class EasyDialogsAnimation implements IEasyDialogsAnimator {
  final EasyDialogsAnimationSettings data;

  EasyDialogsAnimation({
    required this.data,
  });
}

/// Interface of class - Animator for EasyDialogs
/// It's main purpose is to animate provided [Widget] child
abstract class IEasyDialogsAnimator {
  /// Animate widget [child]
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  });
}
