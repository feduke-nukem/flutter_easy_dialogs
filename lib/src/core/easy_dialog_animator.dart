import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/custom/manager/custom_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/positioned/manager/positioned_dialog_manager.dart';

/// Base class of animator for dialogs.
///
/// Its main purpose is to apply an animation to the provided
/// [EasyDialogAnimatorData.dialog].
///
/// It is often used in the method [EasyDialogManager.show],
/// which provides the [AnimationController] to the
/// [EasyDialogAnimatorData.parent] to be used by the decorate method.
///
/// See also:
///
/// * [FullScreenDialogManager.show].
/// * [PositionedDialogManager.show].
///
/// This may help you understand how it is supposed to work or even
/// create your own [CustomDialogManager].
abstract class EasyDialogAnimator<D extends EasyDialogAnimatorData>
    extends EasyDialogDecorator<D> {
  /// Desired curve to be applied to the animation.
  final Curve? curve;

  /// @nodoc
  const EasyDialogAnimator({this.curve});
}

/// This is specific to the [EasyDialogAnimator] data and requires a
/// mandatory [parent] of type [Animation].
///
/// The parent referred to here is actually just an [AnimationController.view]
/// provided by the [EasyDialogManager.show] method.
class EasyDialogAnimatorData extends EasyDialogDecoratorData {
  /// This is what drives the animation created by [EasyDialogAnimator] when it is applied
  /// in the [EasyDialogAnimator.decorate] method.
  final Animation<double> parent;

  /// @nodoc
  const EasyDialogAnimatorData({required this.parent, required super.dialog});
}
