import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator_configuration.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay.dart';

/// {@category Dialog manager}
/// {@category Getting started}
/// {@category Custom}
/// This is the base class for all dialog managers.
///
/// The main idea is that any specific [EasyDialogManager]
/// is responsible for only two things: *`showing`* and *`hiding`* dialogs.
///
/// Therefore, there are two methods: [show] and [hide].
///
/// In other words, this class is responsible for managing dialogs that
/// are specific to it, including:
///
/// * Inserting and removing dialogs from [EasyDialogsOverlay].
/// * Applying any provided [EasyDialogDecorator] or multiple decorators.
abstract class EasyDialogManager<S extends EasyDialogManagerShowParams?,
    H extends EasyDialogManagerHideParams?> {
  /// [IEasyOverlayController] is used for providing [Ticker]
  /// for creating animations and inserting dialogs into [EasyDialogsOverlay].
  @protected
  @nonVirtual
  final IEasyOverlayController overlayController;

  /// Creates an instance of [EasyDialogManager].
  const EasyDialogManager({required this.overlayController});

  /// This is an abstract [show] method with a [params] of type [S].
  ///
  /// This is the core method used for displaying dialogs.
  Future<void> show({required S params});

  /// This is an abstract [hide] method with a [params] of type [H].
  ///
  /// This is the core method used for hiding dialogs.
  Future<void> hide({required H params});
}

/// {@category Dialog manager}
/// {@category Getting started}
/// {@category Custom}
/// Base data class of show params for dialog managers.
class EasyDialogManagerShowParams {
  /// Content for showing.
  final Widget content;

  /// Animator settings.
  final EasyDialogAnimatorConfiguration animationConfiguration;

  /// Creates an instance of [EasyDialogManagerShowParams].
  const EasyDialogManagerShowParams({
    required this.content,
    this.animationConfiguration = const EasyDialogAnimatorConfiguration(),
  });
}

/// {@category Dialog manager}
/// {@category Getting started}
/// {@category Custom}
/// Base class of hide params for dialog managers.
class EasyDialogManagerHideParams {
  /// Creates an instance of [EasyDialogManagerHideParams].
  const EasyDialogManagerHideParams();
}

/// {@category Dialog manager}
/// {@category Getting started}
/// {@category Custom}
/// Simple insert dialog strategy.
class BasicDialogInsertStrategy
    extends EasyOverlayBoxInsert<EasyDialogManager> {
  /// Callback that is fired upon inserting a dialog
  /// into [IEasyDialogsOverlayBox].
  ///
  /// Provides an identifier for the inserted dialog, which can be used for
  /// removing it in the future.
  final Function(int dialogId)? _onInserted;

  const BasicDialogInsertStrategy({
    required super.dialog,
    Function(int dialogId)? onInserted,
  }) : _onInserted = onInserted;

  @override
  EasyOverlayEntry apply(IEasyDialogsOverlayBox box) {
    final container = box.putIfAbsent<List<EasyOverlayEntry>>(key, () => []);

    final entry = EasyDialogsOverlayEntry(builder: (_) => dialog);

    container.add(entry);

    final dialogId = container.indexOf(entry);

    _onInserted?.call(dialogId);

    return entry;
  }
}

/// {@category Dialog manager}
/// {@category Getting started}
/// {@category Custom}
/// Simple implementation of remove strategy.
class BasicDialogRemoveStrategy
    extends EasyOverlayBoxRemove<EasyDialogManager> {
  /// Identifier of dialog that should be removed.
  final int _dialogId;

  /// @nodoc
  const BasicDialogRemoveStrategy({required int dialogId})
      : _dialogId = dialogId;

  @override
  EasyOverlayEntry? apply(IEasyDialogsOverlayBox box) {
    final container = box.get<List<EasyOverlayEntry>>(key);

    assert(container != null, 'container of entries is not initialized');

    final entry =
        ((_dialogId < container!.length) ? container[_dialogId] : null);

    if (entry == null) return null;

    container.removeAt(_dialogId);

    return entry;
  }
}
