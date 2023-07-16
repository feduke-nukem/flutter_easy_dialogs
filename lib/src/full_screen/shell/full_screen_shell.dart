import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'modal_banner.dart';

/// The [EasyDialogDecoration] that is specific to the [FullScreenDialog].
abstract base class FullScreenShell
    extends EasyDialogDecoration<FullScreenDialog> {
  const FullScreenShell();

  /// Applies some [Container] related content modifications.
  const factory FullScreenShell.modalBanner({
    EdgeInsets padding,
    EdgeInsets margin,
    BoxDecoration? boxDecoration,
  }) = _ModalBanner;
}
