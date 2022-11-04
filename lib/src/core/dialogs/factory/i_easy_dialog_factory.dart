import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/easy_dismissible.dart';

abstract class IEasyDialogFactory {
  Widget createDialog({
    required covariant AgentShowParams params,
  });

  IEasyDismissor createDismissible({
    required covariant AgentShowParams params,
    VoidCallback? handleOnDismissed,
  });

  IEasyAnimator createAnimation({
    required covariant AgentShowParams params,
  });
}
