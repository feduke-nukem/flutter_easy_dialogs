import 'package:flutter/material.dart';

import '../../core/core.dart';

/// [EasyDialog] that is shown at a specific [EasyDialogPosition].
final class PositionedDialog extends EasyDialog {
  static const defaultPosition = EasyDialogPosition.top;
  static const defaultAnimationConfiguration =
      const EasyDialogAnimationConfiguration.bounded(
    duration: Duration(milliseconds: 500),
    reverseDuration: Duration(milliseconds: 500),
  );
  static const defaultAutoHideDuration = Duration(seconds: 3);

  /// The position where the dialog will be shown.
  final EasyDialogPosition position;

  /// Creates an instance of [PositionedDialog].
  PositionedDialog({
    required super.content,
    this.position = defaultPosition,
    super.decoration,
    super.animationConfiguration = defaultAnimationConfiguration,
    super.autoHideDuration = defaultAutoHideDuration,
    Object? id,
  }) : super(id: id ?? position);

  @override
  EasyOverlayBoxInsertion createInsert(Widget decorated) {
    return super.createInsert(
      Align(
        alignment: position.alignment,
        child: decorated,
      ),
    );
  }

  @override
  EasyDialog clone() {
    return PositionedDialog(
      content: content,
      position: position,
      decoration: decoration,
      animationConfiguration: animationConfiguration,
      autoHideDuration: autoHideDuration,
      id: id,
    );
  }
}

/// Enum that represents the position of the dialog.
enum EasyDialogPosition {
  top(Alignment.topCenter),
  bottom(Alignment.bottomCenter),
  center(Alignment.center);

  final AlignmentGeometry alignment;

  const EasyDialogPosition(this.alignment);
}
