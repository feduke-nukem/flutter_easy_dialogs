import 'package:flutter_easy_dialogs/src/core/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';

class PositionedDialogHideParams extends AgentHideParams {
  final bool hideAll;

  final EasyDialogPosition? position;

  const PositionedDialogHideParams({
    this.hideAll = false,
    this.position,
  });
}
