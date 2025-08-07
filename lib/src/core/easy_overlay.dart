// ignore_for_file: prefer-match-file-name

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'core.dart';

/// {@category Overlay}
/// {@category Custom}
/// Controller for manipulating overlay with the dialogs.
///
/// It defines the methods for inserting and removing dialogs
/// from an [EasyDialogsOverlayBox].
///
/// It extends the [TickerProvider] interface,
/// which is used for providing animation tickers.
///
/// It is involved to be used for creating [AnimationController]
/// by [EasyDialogsController].
abstract interface class IEasyOverlay implements TickerProvider {
  /// Insert dialog using provided [insertion].
  void insertDialog(EasyOverlayBoxInsertion insertion);

  /// Remove dialog using provided [removal].
  void removeDialog(EasyOverlayBoxRemoval removal);
}

/// {@category Overlay}
/// {@category Custom}
/// Box for storing dialog specific entries.
final class EasyDialogsOverlayBox {
  @visibleForTesting
  final currentEntries = <Object, Object?>{};

  T putIfAbsent<T>(Object key, T Function() ifAbsent) =>
      currentEntries.putIfAbsent(key, ifAbsent) as T;

  T? get<T>(Object key) => currentEntries[key] as T?;

  void put(Object key, Object value) => currentEntries[key] = value;

  T? remove<T>(Object key) => currentEntries.remove(key) as T?;

  bool containsKey(Object key) => currentEntries.containsKey(key);
}

/// {@category Overlay}
/// {@category Custom}
/// Class for applying specific mutation within [EasyDialogsOverlayBox].
///
/// It is intended to be used as a base class for
/// creating custom mutation operations.
///
/// [R] represents the type of the return value for the [call] method,
/// it should extends [EasyOverlayEntry] which can bu nullable.
abstract interface class EasyOverlayBoxMutation<R extends EasyOverlayEntry?> {
  const EasyOverlayBoxMutation();

  /// Apply mutation to provided [box].
  ///
  /// The result is [R].
  R call(EasyDialogsOverlayBox box);
}

/// {@category Overlay}
/// {@category Custom}
/// Insertion mutation.
abstract base class EasyOverlayBoxInsertion
    extends EasyOverlayBoxMutation<EasyOverlayEntry> {
  final Widget dialog;

  /// @nodoc
  const EasyOverlayBoxInsertion({required this.dialog});
}

/// {@category Overlay}
/// {@category Custom}
/// Removal mutation.
abstract base class EasyOverlayBoxRemoval
    extends EasyOverlayBoxMutation<EasyOverlayEntry?> {
  const EasyOverlayBoxRemoval();
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
      SchedulerBinding.instance.addPostFrameCallback((_) {
        super.markNeedsBuild();
      });

      return;
    }

    super.markNeedsBuild();
  }
}

/// {@category Overlay}
/// Simple overlay entry.
base class EasyDialogsOverlayEntry extends EasyOverlayEntry {
  /// Creates an instance of [EasyDialogsOverlayEntry].
  EasyDialogsOverlayEntry({required super.builder});
}

/// {@category Overlay}
/// Default insertion for the [EasyDialogsOverlayBox] based on [id].
final class DefaultEasyOverlayBoxInsertion extends EasyOverlayBoxInsertion {
  final Object id;
  const DefaultEasyOverlayBoxInsertion({
    required this.id,
    required super.dialog,
  });

  @override
  EasyOverlayEntry call(EasyDialogsOverlayBox box) {
    assert(
      !box.containsKey(id),
      'only single one $EasyDialogsOverlayEntry with the same $id can be inserted at the same time',
    );

    final entry = EasyDialogsOverlayEntry(
      builder: (_) => dialog,
    );

    box.put(id, entry);

    return entry;
  }
}

/// {@category Overlay}
/// Default removal for the [EasyDialogsOverlayBox] based on [id].
final class DefaultEasyOverlayBoxRemoval extends EasyOverlayBoxRemoval {
  final Object id;

  const DefaultEasyOverlayBoxRemoval({required this.id});

  @override
  EasyOverlayEntry? call(EasyDialogsOverlayBox box) =>
      box.remove<EasyDialogsOverlayEntry>(id);
}
