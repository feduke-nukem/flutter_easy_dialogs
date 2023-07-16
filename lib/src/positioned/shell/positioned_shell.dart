import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'banner.dart';

/// An [EasyDialogDecoration] specific to the [PositionedDialog].
abstract base class PositionedShell
    extends EasyDialogDecoration<PositionedDialog> {
  /// @nodoc
  const PositionedShell();

  /// Provide some sort of shape to the dialog.
  const factory PositionedShell.banner({
    Color? backgroundColor,
    EdgeInsets padding,
    EdgeInsets margin,
    BorderRadius borderRadius,
  }) = _Banner;
}
