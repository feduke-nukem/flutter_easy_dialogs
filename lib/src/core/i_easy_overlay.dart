import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';

/// {@category Overlay}
/// {@category Custom}
/// Controller for manipulating overlay with the dialogs.
///
/// It defines the methods for inserting and removing dialogs
/// from an [IEasyDialogsOverlayBox].
///
/// It extends the [TickerProvider] interface,
/// which is used for providing animation tickers.
///
/// It is involved to be used for creating [AnimationController]
/// by [EasyDialogsController].
abstract interface class IEasyOverlay implements TickerProvider {
  /// Insert dialog using provided [insertion].
  void insertDialog(EasyOverlayBoxInsert insertion);

  /// Remove dialog using provided [removal].
  void removeDialog(EasyOverlayBoxRemove removal);
}

/// {@category Overlay}
/// {@category Custom}
/// Box for storing dialog specific entries.
abstract interface class IEasyDialogsOverlayBox {
  /// Put [value] with associated [key].
  void put(Object key, Object value);

  /// Remove value of [T] with associated [key].
  T? remove<T>(Object key);

  /// Get [value] with associated [key].
  T? get<T>(Object key);

  /// Put [ifAbsent] with associated [key] if [key] value is `null`.
  T putIfAbsent<T>(Object key, T Function() ifAbsent);
}

/// {@category Overlay}
/// {@category Custom}
/// Similar to Command/Strategy class for applying specific
/// mutation within [IEasyDialogsOverlayBox].
///
/// [M] type is for providing associated derivative from [EasyDialogsController].
///
/// The [EasyOverlayBoxMutation] is similar to Command/Strategy class
/// that defines a mutation operation for an [IEasyDialogsOverlayBox].
///
/// It is intended to be used as a base class for
/// creating custom mutation operations.
///
/// This class has two generic type parameters:
///
/// [M] represents the type of [EasyDialogsController] that this mutation
/// associates to with the [key] getter.
///
/// [R] represents the type of the return value for the [call] method,
/// it should extends [EasyOverlayEntry] which can bu nullable.
abstract interface class EasyOverlayBoxMutation<Dialog extends EasyDialog,
    R extends EasyOverlayEntry?> {
  const EasyOverlayBoxMutation();

  Type get key => Dialog;

  /// Apply mutation to provided [box].
  ///
  /// The result is [R].
  R call(IEasyDialogsOverlayBox box);
}

/// {@category Overlay}
/// {@category Custom}
/// Insert mutation.
abstract base class EasyOverlayBoxInsert<Dialog extends EasyDialog>
    extends EasyOverlayBoxMutation<Dialog, EasyOverlayEntry> {
  final Widget dialog;

  /// @nodoc
  const EasyOverlayBoxInsert({required this.dialog});
}

/// {@category Overlay}
/// {@category Custom}
/// Remove mutation.
abstract base class EasyOverlayBoxRemove<Dialog extends EasyDialog>
    extends EasyOverlayBoxMutation<Dialog, EasyOverlayEntry?> {
  const EasyOverlayBoxRemove();
}

/// {@category Overlay}
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
abstract base class EasyOverlayEntry extends OverlayEntry {
  /// Creates an instance of [EasyOverlayEntry].
  EasyOverlayEntry({required super.builder});

  @override
  void markNeedsBuild() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // coverage:ignore-start
      SchedulerBinding.instance.addPostFrameCallback((_) {
        super.markNeedsBuild();
      });

      return;
    }

    super.markNeedsBuild();
    // coverage:ignore-end
  }
}

/// {@category Overlay}
/// Simple overlay entry.
base class EasyDialogsOverlayEntry extends EasyOverlayEntry {
  /// Creates an instance of [EasyDialogsOverlayEntry].
  EasyDialogsOverlayEntry({required super.builder});
}
