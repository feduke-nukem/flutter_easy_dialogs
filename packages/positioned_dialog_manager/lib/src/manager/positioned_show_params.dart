part of 'positioned_dialog_manager.dart';

const _defaultDuration = Duration(milliseconds: 500);
const _defaultReverseDuration = Duration(milliseconds: 500);

/// Parameters used to show a dialog using the [PositionedDialogManager].
///
/// The [PositionedDialogManager] is a specific implementation
/// of the [EasyDialogManager]
/// that allows for positioning and animating the dialog based on the specified
/// [EasyDialogPosition] and [PositionedAnimator].
///
/// To show a dialog with the [PositionedDialogManager], create an instance of this
/// class and pass it to the [PositionedDialogManager.show] method.
class PositionedShowParams extends EasyDialogManagerShowParams {
  /// The position where the dialog will be shown.
  final EasyDialogPosition position;

  /// [EasyDialogAnimator] specific to [PositionedDialogManager].
  final PositionedAnimator animator;

  /// The duration until the dialog will be hidden automatically.
  ///
  /// If this is `null`, the dialog will not be automatically hidden.
  final Duration? hideAfterDuration;

  /// The dismissible behavior for the dialog.
  final PositionedDismissible dismissible;

  /// The shell used to wrap the dialog content.
  final PositionedDialogShell shell;

  /// Creates an instance of [PositionedShowParams].
  ///
  /// The [content] parameter is required and specifies the content
  /// of the dialog.
  ///
  /// The other parameters are optional and have default values,
  /// as specified below:
  ///
  /// * [position]: The default position is [EasyDialogPosition.top].
  /// * [dismissible]: The default behavior is to dismiss the dialog on tap.
  /// * [autoHideDuration]: The default duration is 3 seconds.
  /// * [animator]: The default animator is [PositionedAnimator.fade].
  /// * [shell]: The default shell is [PositionedDialogShell.banner].
  const PositionedShowParams({
    required super.content,
    this.position = EasyDialogPosition.top,
    this.dismissible = const PositionedDismissible.animatedTap(),
    this.animator = const PositionedAnimator.fade(),
    this.shell = const PositionedDialogShell.banner(),
    this.hideAfterDuration,
    super.animationConfiguration = const EasyDialogAnimatorConfiguration(
      duration: _defaultDuration,
      reverseDuration: _defaultReverseDuration,
    ),
  });
}
