import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_shell.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_scope.dart';
import 'package:flutter_easy_dialogs/src/util/easy_dialog_scope_x.dart';

part 'modal_banner.dart';

abstract class EasyFullScreenDialogShell extends EasyDialogShell {
  const factory EasyFullScreenDialogShell.modalBanner({
    EdgeInsets padding,
    EdgeInsets margin,
    BoxDecoration? boxDecoration,
    Key? key,
  }) = _ModalBanner;
}

class EasyFullScreenScopeData extends EasyDialogScopeData {
  final Widget content;

  const EasyFullScreenScopeData({
    required this.content,
  });

  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is EasyFullScreenScopeData && content == other.content;

  @override
  int get hashCode => Object.hashAll([content]);
}
