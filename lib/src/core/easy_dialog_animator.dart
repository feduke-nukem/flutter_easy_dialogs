import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_manager.dart';
import 'package:flutter_easy_dialogs/src/positioned/manager/positioned_manager.dart';

/// Base class of animator for Easy Dialogs.
///
/// It is a different kind of abstraction than [IEasyDialogAnimator] as it
/// can possibly be extended with functionality and some properties in future.
abstract class EasyDialogAnimator implements IEasyDialogAnimator {
  /// Desired curve to be applied to the animation.
  final Curve? curve;

  /// @nodoc
  const EasyDialogAnimator({this.curve});

  /// Combines provided [animators] sequentially.
  factory EasyDialogAnimator.combine({
    required Iterable<EasyDialogAnimator> animators,
  }) = _MultipleEasyDialogAnimator;
}

/// Its main purpose is to apply an animation to the provided [Widget] child.
///
/// It is often used in the [EasyDialogManager.show] method,
/// which provides the [AnimationController] to be used by the [animate] method.
///
/// See also:
///
/// * [FullScreenManager.show].
/// * [PositionedManager.show].
///
/// This may help you understand how it is supposed to work or even
/// create your own custom [EasyDialogManager].
abstract class IEasyDialogAnimator {
  /// ### Animate [child] driven by [parent].
  Widget animate({
    required Animation<double> parent,
    required Widget child,
  });
}

class _MultipleEasyDialogAnimator extends EasyDialogAnimator {
  final Iterable animators;

  const _MultipleEasyDialogAnimator({
    required this.animators,
  }) : assert(animators.length > 0, 'animators should not be empty');

  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    Widget result = child;

    for (final animator in animators) {
      result = animator.animate(parent: parent, child: result);
    }

    return result;
  }
}
