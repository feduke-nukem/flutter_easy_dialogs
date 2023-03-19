import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_scope.dart';
import 'package:flutter_easy_dialogs/src/positioned/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_shell.dart';
import 'package:flutter_easy_dialogs/src/util/easy_dialog_scope_x.dart';

part 'banner.dart';

abstract class EasyPositionedDialogShell extends EasyDialogShell {
  const factory EasyPositionedDialogShell.banner({
    Color? backgroundColor,
    EdgeInsets padding,
    EdgeInsets margin,
    BorderRadius borderRadius,
    Key? key,
  }) = _Banner;
}

class EasyPositionedScopeData extends EasyDialogScopeData {
  final EasyDialogPosition position;
  final Widget content;

  const EasyPositionedScopeData({
    required this.position,
    required this.content,
  });

  bool operator ==(Object? other) =>
      identical(this, other) ||
      other is EasyPositionedScopeData &&
          position == other.position &&
          content == other.content;

  @override
  int get hashCode => Object.hashAll([position, content]);
}
