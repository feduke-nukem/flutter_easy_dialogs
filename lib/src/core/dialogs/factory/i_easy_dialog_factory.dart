import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/easy_dismissible.dart';

/// Interface of Abstract Factory for dialogs
abstract class IEasyDialogFactory {
  /// Create dialog using [AgentShowParams]
  Widget createDialog({
    required covariant AgentShowParams params,
  });

  /// Create dismissible using [AgentShowParams]
  IEasyDismissor createDismissible({
    required covariant AgentShowParams params,
    VoidCallback? handleOnDismissed,
  });

  /// Create animation using [AgentShowParams]
  IEasyAnimator createAnimation({
    required covariant AgentShowParams params,
  });
}
