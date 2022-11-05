import 'package:flutter_easy_dialogs/src/core/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/core/agents/positioned_dialog_agent.dart/positioned_dialog_agent.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_position.dart';

/// Hide params for [PositionedDialogAgent]
class PositionedDialogHideParams extends AgentHideParams {
  /// If is true - all presented dialogs of associated [PositionedDialogAgent]
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
