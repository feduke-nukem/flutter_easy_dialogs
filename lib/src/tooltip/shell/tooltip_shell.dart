import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'bubble.dart';

/// An [EasyDialogDecoration] specific to the [TooltipDialog].
abstract base class TooltipShell extends EasyDialogDecoration<TooltipDialog> {
  /// @nodoc
  const TooltipShell();

  /// Bubble with an arrow pointing to the target.
  ///
  /// The arrow side is derived from [TooltipDialog.alignment].
  const factory TooltipShell.bubble({
    Color? backgroundColor,
    EdgeInsets padding,
    BorderRadius borderRadius,
    BorderSide side,
    double arrowLength,
    double arrowBaseWidth,
    List<BoxShadow> shadows,
    TextStyle? textStyle,
  }) = _Bubble;
}
