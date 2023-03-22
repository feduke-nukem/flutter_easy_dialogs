import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_widget.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_scope.dart';

part 'modal_banner.dart';

abstract class EasyFullScreenDialogShell
    extends EasyDialogShell<EasyFullScreenScopeData>
    implements IEasyDialogDecorator {
  const EasyFullScreenDialogShell({super.key});

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

// TODO: Rethink about replacing Animators, Dismissibles and Shells with that
abstract class IEasyDialogDecorator {
  Widget configure(Widget child);
}
