import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/core/managers/easy_dialog_manager_base.dart';
import 'package:flutter_easy_dialogs/src/core/managers/positioned_dialog_manager/positioned_dialog_manager.dart';

/// Hide params for [PositionedDialogManager]
class PositionedDialogHideParams extends ManagerHideParamsBase {
  /// If is true - all presented dialogs of associated [PositionedDialogManager]
  /// will be removed
  final bool hideAll;

  /// Position of the dialog for removing
  final EasyDialogPosition? position;

  /// Creates an instance of [PositionedDialogHideParams]
  const PositionedDialogHideParams({
    this.hideAll = false,
    this.position,
  });
}
