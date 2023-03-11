import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// Interface of Abstract Factory for dialogs
abstract class IEasyDialogFactory<S extends ManagerShowParamsBase> {
  /// Create dialog using [ManagerShowParamsBase]
  Widget createDialog({
    required S params,
  });

  /// Create dismissible using [ManagerShowParamsBase]
  IEasyDismissor createDismissible({
    required S params,
    VoidCallback? handleOnDismissed,
  });

  /// Create animation using [ManagerShowParamsBase]
  IEasyAnimator createAnimation({
    required S params,
  });
}
