import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';

/// Controller for manipulating overlay with the dialogs.
///
/// It defines the methods for inserting and removing dialogs
/// from an [IEasyDialogsOverlayBox].
///
/// It extends the [TickerProvider] interface,
/// which is used for providing animation tickers.
///
/// It is involved to be used for creating [AnimationController]
/// by [EasyDialogManager].
abstract class IEasyOverlayController implements TickerProvider {
  /// Insert dialog using provided [strategy].
  void insertDialog(EasyOverlayBoxInsert strategy);

  /// Remove dialog using provided [strategy].
  void removeDialog(EasyOverlayBoxRemove strategy);
}

/// Box for storing dialog specific entries.
abstract class IEasyDialogsOverlayBox {
  /// Put [value] with associated [key].
  void put(Object key, Object value);

  /// Remove value of [T] with associated [key].
  T? remove<T>(Object key);

  /// Get [value] with associated [key].
  T? get<T>(Object key);

  /// Put [ifAbsent] with associated [key] if [key] value is `null`.
  T putIfAbsent<T>(Object key, T Function() ifAbsent);
}

/// Similar to Command/Strategy class for applying specific
/// mutation within [IEasyDialogsOverlayBox].
///
/// [M] type is for providing associated derivative from [EasyDialogManager].
///
/// The [EasyOverlayBoxMutation] is similar to Command/Strategy class
/// that defines a mutation operation for an [IEasyDialogsOverlayBox].
///
/// It is intended to be used as a base class for
/// creating custom mutation operations.
///
/// This class has two generic type parameters:
///
/// [M] represents the type of [EasyDialogManager] that this mutation
/// associates to with the [key] getter.
///
/// [R] represents the type of the return value for the [apply] method,
/// it should extends [EasyOverlayEntry] which can bu nullable.
abstract class EasyOverlayBoxMutation<M extends EasyDialogManager,
    R extends EasyOverlayEntry?> {
  const EasyOverlayBoxMutation();

  Type get key => M;

  /// Apply mutation to provided [box].
  ///
  /// The result is [R].
  R apply(IEasyDialogsOverlayBox box);
}

/// Insert mutation.
abstract class EasyOverlayBoxInsert<M extends EasyDialogManager>
    extends EasyOverlayBoxMutation<M, EasyOverlayEntry> {
  final Widget dialog;

  /// @nodoc
  const EasyOverlayBoxInsert({required this.dialog});
}

/// Remove mutation.
abstract class EasyOverlayBoxRemove<M extends EasyDialogManager>
    extends EasyOverlayBoxMutation<M, EasyOverlayEntry?> {
  const EasyOverlayBoxRemove();
}

/// The EasyOverlayEntry class is an abstract class that
/// extends [OverlayEntry].
///
/// It is designed to be used as a base class for creating
/// custom overlay entries.
///
/// The class overrides the [markNeedsBuild]
/// method to ensure that the widget
/// is only rebuilt during the [SchedulerPhase.persistentCallbacks]
/// phase.
///
/// If the method is called during any other phase,
/// it schedules a [SchedulerBinding.addPostFrameCallback]
/// to ensure that the widget is rebuilt during the
/// [SchedulerPhase.persistentCallbacks] phase.
abstract class EasyOverlayEntry extends OverlayEntry {
  /// Creates an instance of [EasyOverlayEntry].
  EasyOverlayEntry({required super.builder});

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

/// Simple overlay entry.
class EasyDialogsOverlayEntry extends EasyOverlayEntry {
  /// Creates an instance of [EasyDialogsOverlayEntry].
  EasyDialogsOverlayEntry({required super.builder});
}
