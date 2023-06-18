import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'banner.dart';

/// An [EasyDialogDecorator] specific to the [PositionedConversation].
abstract base class PositionedDialogShell extends EasyDialogDecorator {
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
