import 'package:flutter_easy_dialogs/src/positioned/easy_dialog_position.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/positioned/manager/positioned_dialog_manager.dart';

/// Hide params for [PositionedDialogManager].
class PositionedHideParams extends EasyDialogManagerHideParams {
  /// If is `true`, all associated with the [PositionedDialogManager]
  /// will be hidden.
  final bool hideAll;

  /// Position of the dialog for removing.
  final EasyDialogPosition? position;

  /// Creates an instance of [PositionedHideParams].
  const PositionedHideParams({
    this.hideAll = false,
    this.position,
  });
}
