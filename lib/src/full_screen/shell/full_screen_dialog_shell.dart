import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dialog/full_screen_dialog_conversation.dart';

part 'modal_banner.dart';

/// The [EasyDialogDecorator] that is specific to the [FullScreenDialogConversation].
abstract base class FullScreenDialogShell extends EasyDialogDecorator {
  const FullScreenDialogShell();

  /// Applies some [Container] related content modifications.
  const factory FullScreenDialogShell.modalBanner({
    EdgeInsets padding,
    EdgeInsets margin,
    BoxDecoration? boxDecoration,
  }) = _ModalBanner;
}
