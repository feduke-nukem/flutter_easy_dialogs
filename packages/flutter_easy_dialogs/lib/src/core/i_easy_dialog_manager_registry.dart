import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/easy_dialog_manager_controller/easy_dialog_manager_controller.dart';

/// {@category Registering and using}
/// Class that is responsible for registering [EasyDialogManager].
abstract class IEasyDialogManagerRegistry {
  /// Register manager.
  void register<M extends EasyDialogManager>(
    EasyDialogManagerFactory<M> factory,
  );

  /// Unregister manager.
  void unregister<M extends EasyDialogManager>();
}
