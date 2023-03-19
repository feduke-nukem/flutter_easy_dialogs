import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';

/// Controller for manipulating overlay with the dialogs.
abstract class IEasyOverlayController implements TickerProvider {
  void insertDialog(EasyOverlayBoxInsert strategy);

  void removeDialog(EasyOverlayBoxRemove strategy);
}

/// Box for storing EasyDialogs specific entries.
abstract class IEasyOverlayBox {
  /// Put [value] with associated [key].
  void put(Object key, Object value);

  /// Remove value of [T] with associated [key].
  T? remove<T>(Object key);

  /// Get [value] with associated [key].
  T? get<T>(Object key);

  /// Put [ifAbsent] with associated [key] if [key] value is `null`.
  T putIfAbsent<T>(Object key, T Function() ifAbsent);
}

/// Similar to Command/Strategy class for applying specific mutation within [IEasyOverlayBox].
///
/// [M] type is for providing associated derivative from [EasyDialogManager].
abstract class EasyOverlayBoxMutation<M extends EasyDialogManager,
    R extends EasyOverlayEntry?> {
  const EasyOverlayBoxMutation();

  Type get key => M;

  /// Apply mutation to provided [box].
  ///
  /// The result is [R].
  R apply(IEasyOverlayBox box);
}

/// Insert mutation.
abstract class EasyOverlayBoxInsert<M extends EasyDialogManager>
    extends EasyOverlayBoxMutation<M, EasyOverlayEntry> {
  final Widget dialog;

  const EasyOverlayBoxInsert({
    required this.dialog,
  });
}

/// Remove mutation.
abstract class EasyOverlayBoxRemove<M extends EasyDialogManager>
    extends EasyOverlayBoxMutation<M, EasyOverlayEntry?> {
  const EasyOverlayBoxRemove();
}

/// Core class of extended [OverlayEntry].
abstract class EasyOverlayEntry extends OverlayEntry {
  /// Creates an instance of [EasyOverlayEntry].
  EasyOverlayEntry({
    required super.builder,
  });

  @override
  void markNeedsBuild() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        super.markNeedsBuild();
      });

      return;
    }

    super.markNeedsBuild();
  }
}
