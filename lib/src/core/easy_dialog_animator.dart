import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';

/// {@category Decorators}
/// {@category Custom}
/// Base class of animator for dialogs.
///
/// Its main purpose is to apply an animation to the provided
/// [EasyDialogAnimation.dialog].
///
/// It is often used in the method [EasyDialogsController.show],
/// which provides the [AnimationController] to the
/// [EasyDialogAnimation.parent] to be used by the decorate method.
///
/// This may help you understand how it is supposed to work or even
/// create your own [EasyDialogsController].
abstract base class EasyDialogAnimator extends EasyDialogDecorator {
  /// @nodoc
  const EasyDialogAnimator({this.curve = Curves.linear});

  /// Desired curve to be applied to the animation.
  final Curve curve;
}
