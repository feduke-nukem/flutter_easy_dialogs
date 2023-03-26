import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';

typedef EasyDialogManagerFactory<M extends EasyDialogManager> = M Function();

/// This class is responsible for storing registered instances
/// of [EasyDialogManager].
///
/// It handles lazy [get] calls for registered instances,
/// so it's safe to register a lot of managers.
class EasyDialogManagerBox {
  @visibleForTesting
  late final managers = <Type, Object>{};

  /// Put [factory] into the box.
  void put<M extends EasyDialogManager>(
    EasyDialogManagerFactory<M> factory,
  ) {
    assert(
      !managers.containsKey(M),
      'Manager factory is already registered',
    );
    managers[M] = factory;
  }

  /// Get manager instance of type [M].
  M get<M extends EasyDialogManager>() {
    assert(managers.containsKey(M));

    final target = managers[M]!;

    // Factory has already created target instance
    if (target is M) return target;

    final factory = _getFactory<M>();

    final manager = factory();

    _shadowFactory<M>(manager);

    return manager;
  }

  /// Remove stored manager instance of type [M].
  void remove<M extends EasyDialogManager>() => managers.remove(M);

  void _shadowFactory<M extends EasyDialogManager>(M manager) =>
      managers[M] = manager;

  EasyDialogManagerFactory<M> _getFactory<M extends EasyDialogManager>() {
    assert(managers.containsKey(M));

    return managers[M]! as EasyDialogManagerFactory<M>;
  }
}
