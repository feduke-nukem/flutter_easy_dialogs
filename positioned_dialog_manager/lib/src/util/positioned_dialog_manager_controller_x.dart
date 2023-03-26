
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';
import 'package:positioned_dialog_manager/src/manager/positioned_dialog_manager.dart';

extension PositionedDialogManagerControllerX on IEasyDialogManagerController {
  Future<void> showPositioned(PositionedShowParams params) =>
      use<PositionedDialogManager>().show(params: params);

  Future<void> hidePositioned(EasyDialogPosition position) =>
      use<PositionedDialogManager>()
          .hide(params: PositionedHideParams(position: position));

  Future<void> hideAllPositioned() => use<PositionedDialogManager>().hide(
        params: const PositionedHideParams(hideAll: true),
      );
}
