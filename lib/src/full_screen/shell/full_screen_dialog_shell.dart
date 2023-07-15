import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

part 'modal_banner.dart';

/// The [EasyDialogDecoration] that is specific to the [FullScreenDialog].
abstract base class FullScreenDialogShell
    extends EasyDialogDecoration<FullScreenDialog> {
  const FullScreenDialogShell();

  /// Applies some [Container] related content modifications.
  const factory FullScreenDialogShell.modalBanner({
    EdgeInsets padding,
    EdgeInsets margin,
    BoxDecoration? boxDecoration,
  }) = _ModalBanner;
}
