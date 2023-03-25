import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';

part 'modal_banner.dart';

/// The [EasyDialogDecorator] that is specific to the [FullScreenDialogManager].
abstract class FullScreenDialogShell
    extends EasyDialogDecorator<EasyDialogDecoratorData> {
  const FullScreenDialogShell();

  /// Applies some [Container] related content modifications.
  const factory FullScreenDialogShell.modalBanner({
    EdgeInsets padding,
    EdgeInsets margin,
    BoxDecoration? boxDecoration,
  }) = _ModalBanner;
}
