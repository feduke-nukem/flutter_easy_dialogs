part of 'easy_dialogs_controller.dart';

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
abstract base class EasyDialogAnimation<Dialog extends EasyDialog>
    extends EasyDialogDecoration<Dialog> {
  /// Desired curve to be applied to the animation.
  final Curve curve;

  /// @nodoc
  const EasyDialogAnimation({this.curve = Curves.linear});
}
