import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/core/animations/easy_animation.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/easy_dismissible.dart';

abstract class IEasyDialogFactory {
  EasyDialogType get dialogType;

  Widget createDialog({
    required covariant ShowParams params,
  });

  IEasyDismissor createDismissible({
    required covariant ShowParams params,
    VoidCallback? handleOnDismissed,
  });

  IEasyAnimator createAnimation({
    required covariant ShowParams params,
  });
}
