import 'package:flutter_easy_dialogs/src/core/agents/compose_interfaces.dart';
import 'package:flutter_easy_dialogs/src/core/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';

class PositionedDialogHideParams extends HideParams
    implements IPositionableSettings {
  final bool hideAll;
  @override
  final EasyDialogPosition? position;

  const PositionedDialogHideParams({
    this.hideAll = false,
    this.position,
  });
}
