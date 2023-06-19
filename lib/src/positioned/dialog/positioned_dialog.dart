part of 'positioned_dialog_conversation.dart';

const _defaultDuration = Duration(milliseconds: 500);
const _defaultReverseDuration = Duration(milliseconds: 500);

/// Parameters used to show a dialog using the [PositionedDialogConversation].
///
/// The [PositionedDialogConversation] is a specific implementation
/// of the [EasyDialogsController]
/// that allows for positioning and animating the dialog based on the specified
/// [EasyDialogPosition] and [PositionedAnimator].
///
/// To show a dialog with the [PositionedDialogConversation], create an instance of this
/// class and pass it to the [PositionedDialogConversation.show] method.
final class PositionedDialog extends EasyDialog {
  /// Creates an instance of [PositionedDialog].
  ///
  /// The [child] parameter is required and specifies the content
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
  PositionedDialog({
    required super.child,
    super.shells = const [PositionedDialogShell.banner()],
    super.animators = const [PositionedAnimator.fade()],
    super.dismissibles = const [PositionedDismissible.animatedTap()],
    this.position = EasyDialogPosition.top,
    this.hideAfterDuration,
    super.animationConfiguration = const EasyDialogAnimationConfiguration(
      duration: _defaultDuration,
      reverseDuration: _defaultReverseDuration,
    ),
  });

  /// The position where the dialog will be shown.
  final EasyDialogPosition position;

  /// The duration until the dialog will be hidden automatically.
  ///
  /// If this is `null`, the dialog will not be automatically hidden.
  final Duration? hideAfterDuration;

  static PositionedHide hide({
    bool hideAll = false,
    EasyDialogPosition? position,
  }) {
    return PositionedHide(
      hideAll: hideAll,
      position: position,
    );
  }

  @override
  EasyDialogConversation createConversation() => PositionedDialogConversation();

  @override
  Object get identity => position;

  @override
  EasyOverlayBoxInsert<EasyDialog> createInsert() {
    return PositionedDialogInsert(
      position: position,
      dialog: Align(
        alignment: position.alignment,
        child: child,
      ),
    );
  }

  @override
  EasyOverlayBoxRemove<EasyDialog> createRemove() =>
      PositionedDialogRemove(position: position);
}

/// Hide params for [PositionedDialogConversation].
class PositionedHide extends EasyDialogHide<PositionedDialog> {
  /// Creates an instance of [PositionedHide].
  const PositionedHide({
    this.hideAll = false,
    this.position,
  });

  /// If is `true`, all associated with the [PositionedDialogConversation]
  /// will be hidden.
  final bool hideAll;

  /// Position of the dialog for removing.
  final EasyDialogPosition? position;

  @override
  Object get identity => position ?? PositionedDialog;
}
