import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_dialog.dart';

/// Dialog banner
class DialogBanner extends EasyDialogBase {
  const DialogBanner({
    required super.child,
    required super.animation,
    super.onCotrollPanelCreated,
    super.key,
  });

  /// Creates instance of [DialogBanner]

  @override
  EasyDialogBaseState createState() => _DialogBannerState();
}

class _DialogBannerState extends EasyDialogBaseState {
  @override
  Widget buildDialog(Widget content) {
    return content;
  }
}
