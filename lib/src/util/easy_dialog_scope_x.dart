import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_scope.dart';

extension EasyDialogScopeX on BuildContext {
  D readDialog<D extends EasyDialogScopeData>() =>
      EasyDialogScope.of<D>(this, listen: false);
}
