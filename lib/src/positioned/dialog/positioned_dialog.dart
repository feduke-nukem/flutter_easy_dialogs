part of 'positioned_dialog_conversation.dart';

/// Parameters used to show a dialog using the [PositionedDialogConversation].
///
/// The [PositionedDialogConversation] is a specific implementation
/// of the [EasyDialogsController]
/// that allows for positioning and animating the dialog based on the specified
/// [EasyDialogPosition] and [PositionedAnimation].
///
/// To show a dialog with the [PositionedDialogConversation], create an instance of this
/// class and pass it to the [PositionedDialogConversation.show] method.
final class PositionedDialog extends EasyDialog {
  static const defaultShell = PositionedDialogShell.banner();
  static const defaultAnimation = PositionedAnimation.fade();
  static const defaultDismissible = PositionedDismiss.animatedTap();

  /// The position where the dialog will be shown.
  final EasyDialogShowPosition position;

  /// The duration until the dialog will be hidden automatically.
  ///
  /// If this is `null`, the dialog will not be automatically hidden.
  final Duration? hideAfterDuration;

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
    required super.content,
    this.position = EasyDialogPosition.top,
    super.decoration = const EasyDialogDecoration.combine([
      defaultShell,
      defaultAnimation,
      defaultDismissible,
    ]),
    super.animationConfiguration = const EasyDialogAnimationConfiguration(
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
    ),
    this.hideAfterDuration = const Duration(seconds: 3),
  });

  @factory
  static PositionedHiding createHiding({
    required EasyDialogPosition position,
  }) {
    return PositionedHiding(position: position);
  }

  @override
  EasyDialogConversation createConversation() => PositionedDialogConversation();

  @override
  EasyDialogShowPosition get identity => position;

  @override
  EasyOverlayBoxInsert<EasyDialog> createInsert(Widget decorated) {
    return PositionedDialogInsert(
      position: position,
      dialog: Align(
        alignment: position.alignment,
        child: decorated,
      ),
    );
  }

  @override
  EasyOverlayBoxRemove<EasyDialog> createRemove() =>
      PositionedDialogRemove(position: position);
}

/// Hide params for [PositionedDialogConversation].
class PositionedHiding extends EasyDialogHiding<PositionedDialog> {
  /// Creates an instance of [PositionedHiding].
  const PositionedHiding({
    required this.position,
  });

  /// Position of the dialog for removing.
  final EasyDialogPosition position;

  @override
  EasyDialogPosition get identity => position;
}

sealed class EasyDialogPosition {
  const EasyDialogPosition._();

  static const top = EasyDialogTopPosition();
  static const bottom = EasyDialogBottomPosition();
  static const center = EasyDialogCenterPosition();
  static const all = EasyDialogAllPositions();

  String get name => switch (this) {
        EasyDialogTopPosition _ => 'top',
        EasyDialogBottomPosition _ => 'bottom',
        EasyDialogCenterPosition _ => 'center',
        EasyDialogAllPositions _ => 'all',
      };
}

sealed class EasyDialogShowPosition extends EasyDialogPosition {
  const EasyDialogShowPosition._() : super._();

  Alignment get alignment;
}

final class EasyDialogTopPosition extends EasyDialogShowPosition {
  const EasyDialogTopPosition() : super._();

  @override
  Alignment get alignment => Alignment.topCenter;
}

final class EasyDialogBottomPosition extends EasyDialogShowPosition {
  const EasyDialogBottomPosition() : super._();

  @override
  Alignment get alignment => Alignment.bottomCenter;
}

final class EasyDialogCenterPosition extends EasyDialogShowPosition {
  const EasyDialogCenterPosition() : super._();

  @override
  Alignment get alignment => Alignment.center;
}

sealed class EasyDialogHidePosition extends EasyDialogPosition {
  const EasyDialogHidePosition._() : super._();
}

final class EasyDialogAllPositions extends EasyDialogHidePosition {
  const EasyDialogAllPositions() : super._();
}
