import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// Interface of Abstract Factory for dialogs
abstract class IEasyDialogFactory {
  /// Create dialog using [ManagerShowParamsBase]
  Widget createDialog({
    required covariant ManagerShowParamsBase params,
  });

  /// Create dismissible using [ManagerShowParamsBase]
  IEasyDismissor createDismissible({
    required covariant ManagerShowParamsBase params,
    VoidCallback? handleOnDismissed,
  });

  /// Create animation using [ManagerShowParamsBase]
  IEasyAnimator createAnimation({
    required covariant ManagerShowParamsBase params,
  });
}
