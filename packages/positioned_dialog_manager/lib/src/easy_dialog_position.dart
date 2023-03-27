import 'package:flutter/rendering.dart';

/// Dialog positions.
enum EasyDialogPosition {
  /// Aligned to the top of the screen.
  top(Alignment.topCenter),

  /// Aligned to the bottom of the screen.
  bottom(Alignment.bottomCenter),

  /// Aligned to the center of the screen.
  center(Alignment.center);

  /// @nodoc
  final Alignment alignment;

  /// @nodoc
  const EasyDialogPosition(this.alignment);
}
