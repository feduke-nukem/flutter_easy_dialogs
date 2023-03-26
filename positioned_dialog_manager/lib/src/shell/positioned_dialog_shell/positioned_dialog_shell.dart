import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';
import 'package:positioned_dialog_manager/src/manager/positioned_dialog_manager.dart';

part 'banner.dart';

/// An [EasyDialogDecorator] specific to the [PositionedDialogManager].
abstract class PositionedDialogShell
    extends EasyDialogDecorator<PositionedDialogShellData> {
  /// @nodoc
  const PositionedDialogShell();

  /// Provide some sort of shape to the dialog.
  const factory PositionedDialogShell.banner({
    Color? backgroundColor,
    EdgeInsets padding,
    EdgeInsets margin,
    BorderRadius borderRadius,
  }) = _Banner;
}

/// The data that is specific to the [PositionedDialogShell].
class PositionedDialogShellData extends EasyDialogDecoratorData {
  /// Position of a [dialog].
  final EasyDialogPosition position;

  /// @nodoc.
  const PositionedDialogShellData({
    required this.position,
    required super.dialog,
  });
}
