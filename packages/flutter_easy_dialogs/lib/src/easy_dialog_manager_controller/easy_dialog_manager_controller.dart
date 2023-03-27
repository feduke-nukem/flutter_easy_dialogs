// ignore_for_file: no-magic-number

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/easy_dialog_manager_controller/easy_dialog_manager_box.dart';

export 'easy_dialog_manager_box.dart' show EasyDialogManagerFactory;

/// This controller is responsible for accessing and registering
/// [EasyDialogManager] instances.
class EasyDialogManagerController
    implements IEasyDialogManagerProvider, IEasyDialogManagerRegistry {
  @visibleForTesting
  late final managers = EasyDialogManagerBox();

  /// Creates an instance of [EasyDialogManagerController].
  EasyDialogManagerController();

  @override
  M use<M extends EasyDialogManager>() => managers.get<M>();

  @override
  void register<M extends EasyDialogManager>(
    EasyDialogManagerFactory<M> factory,
  ) =>
      managers.put<M>(factory);

  @override
  void unregister<M extends EasyDialogManager>() => managers.remove<M>();
}
