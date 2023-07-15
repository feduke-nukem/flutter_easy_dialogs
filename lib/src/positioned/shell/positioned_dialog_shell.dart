import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'banner.dart';

/// An [EasyDialogDecoration] specific to the [PositionedDialog].
abstract base class PositionedDialogShell
    extends EasyDialogDecoration<PositionedDialog> {
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
