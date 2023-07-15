import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

import 'core.dart';

part 'easy_dialog_decoration.dart';
part 'easy_dialog_animation.dart';
part 'easy_dialog_dismiss.dart';

/// {@category Dialogs}
/// {@category Getting started}
/// Core class for manipulating dialogs.
final class EasyDialogsController {
  @visibleForTesting
  final entries = <Object, _DialogEntry>{};

  /// [IEasyOverlay] is used for providing [Ticker]
  /// for creating animations and inserting dialogs into [EasyDialogsOverlay].
  @visibleForTesting
  final IEasyOverlay overlay;

  /// Creates an instance of [EasyDialogsController].
  EasyDialogsController(this.overlay);

  /// {@template easy_dialogs_controller.show}
  /// The [show] method is used to display a dialog.
  ///
  /// It could be awaited for a result.
  ///
  /// The result is the value of [T] that is passed to the [hide] method
  /// or when [EasyDialogDismiss.onDismissed] is fired.
  /// {@endtemplate}
  Future<T?> show<T extends Object?>(EasyDialog dialog) async {
    assert(dialog.state == EasyDialogLifecycleState.created);

    final oldEntry = entries[dialog.identity];

    if (oldEntry != null) await _hide(oldEntry.dialog);

    final entry = _createEntry<T>(dialog);

    overlay.insertDialog(dialog._createInsert());

    final needStart = switch (dialog.animationConfiguration) {
      AnimationConfigurationWithController c => c.willForward,
      _ => true,
    };

    if (needStart) await entry.animationController.forward();

    final result = await entry.dialog._completer.future;

    return result as T?;
  }

  /// {@template easy_dialogs_controller.hide}
  /// This method is used to [hide] a dialog.
  ///
  /// [EasyDialogIdentifier] is used to identify the specific dialog.
  ///
  /// [instantly] is used to hide the dialog instantly without animation.
  ///
  /// [result] is used to return a value to the [show] method.
  /// {@endtemplate}
  Future<void> hide(
    EasyDialogIdentifier identifier, {
    bool instantly = false,
    Object? result,
  }) =>
      _hide(
        identifier,
        instantly: instantly,
        result: result,
      );

  /// {@template easy_dialogs_controller.hideWhereType}
  /// This method is used to hide all dialogs of a specific type [D].
  /// {@endtemplate}
  Future<void> hideWhereType<D extends EasyDialog>({bool instantly = false}) =>
      Future.wait(
        entries.values.where((entry) => entry.dialog is D).map(
              (e) => _hide(
                e.dialog,
                instantly: instantly,
              ),
            ),
      );

  /// {@template easy_dialogs_controller.hideWhere}
  /// This method is used to hide all dialogs that satisfy the condition.
  /// {@endtemplate}
  Future<void> hideWhere<D extends EasyDialog>(
    bool Function(D dialog) test, {
    bool instantly = false,
  }) =>
      Future.wait(
        entries.values.where(
          (entry) {
            final dialog = entry.dialog;

            if (dialog is D && test(dialog)) return true;

            return false;
          },
        ).map(
          (e) => _hide(
            e.dialog,
            instantly: instantly,
          ),
        ),
      );

  /// @nodoc
  void dispose() {
    entries.values.forEach((entry) => entry.dispose());
    entries.clear();
  }

  @protected
  AnimationController _getAnimationController(EasyDialogIdentifier identifier) {
    assert(
      entries.containsKey(identifier.identity),
      'dialog is not registered in this conversation',
    );

    return entries[identifier.identity]!.animationController;
  }

  _DialogEntry _createEntry<T extends Object?>(EasyDialog dialog) {
    final entry = _DialogEntry(
      dialog: dialog.._completer = Completer<T?>(),
      animationController: switch (dialog.animationConfiguration) {
        AnimationConfigurationWithController c => c.controller,
        AnimationConfigurationWithoutController c => c.createController(overlay)
      },
    );
    assert(!entries.containsKey(dialog.identity));

    entries[dialog.identity] = entry;
    dialog._context = EasyDialogContext._(
      dialog: dialog,
      controller: this,
    );

    dialog.init();

    entry.animationController.addStatusListener(
      _AnimationStatusListener(controller: this, entry: entry),
    );

    return entry;
  }

  Future<void> _hide(
    EasyDialogIdentifier identifier, {
    bool instantly = false,
    Object? result,
  }) async {
    assert(
      entries[identifier.identity] != null,
      'dialog is not registered in this conversation',
    );

    final entry = entries[identifier.identity]!;
    entry.dialog._pendingResult = result;

    final needReverseAnimation = switch (entry.dialog.animationConfiguration) {
      AnimationConfigurationWithController c => c.willReverse,
      _ => true,
    };

    if (needReverseAnimation) {
      instantly
          ? entry.animationController.value = 0.0
          : await entry.animationController.reverse();
    }

    await entry.dialog._completer.future;
  }

  void _releaseEntry(_DialogEntry entry) {
    assert(
      identical(
        entries[entry.dialog.identity]?.animationController,
        entry.animationController,
      ),
    );
    assert(entry.dialog._completer.isCompleted);

    entries.remove(entry.dialog.identity);
    overlay.removeDialog(entry.dialog.createRemove());
    entry.dispose();
  }
}

class _AnimationStatusListener {
  final EasyDialogsController controller;
  final _DialogEntry entry;

  const _AnimationStatusListener({
    required this.controller,
    required this.entry,
  });

  Future<void> call(AnimationStatus status) async {
    final dialog = entry.dialog;

    switch (status) {
      case AnimationStatus.forward:
        dialog.onShow();
      case AnimationStatus.completed:
        dialog.onShown();

        final needReverseAnimation = switch (dialog.animationConfiguration) {
          AnimationConfigurationWithController c => c.willReverse,
          _ => true,
        };

        if (dialog.autoHideDuration == null || !needReverseAnimation) return;

        await Future.delayed(dialog.autoHideDuration!);

        if (entry.animationController.isDismissed ||
            dialog._completer.isCompleted) return;

        await entry.animationController.reverse();
      case AnimationStatus.reverse:
        dialog.onHide();
      case AnimationStatus.dismissed:
        assert(
          identical(
            controller.entries[dialog.identity]?.animationController,
            entry.animationController,
          ),
        );

        dialog.onHidden();
        dialog._complete();
        entry.animationController.removeStatusListener(this);
        controller._releaseEntry(entry);
    }
  }
}

/// [EasyDialog] lifecycle.
abstract mixin class EasyDialogLifecycle {
  /// Called when the dialog is created and mounted.
  @protected
  void init() {}

  /// Called when the dialog showing was started.
  @protected
  void onShow() {}

  /// Called when the dialog showing was completed.
  @protected
  void onShown() {}

  /// Called when the dialog hiding was started.
  @protected
  void onHide() {}

  /// Called when the dialog hiding was completed.
  @protected
  void onHidden() {}

  /// Called when the dialog was disposed.
  @protected
  void dispose() {}
}

/// Identifier to recognize dialogs withing [EasyDialogsController].
abstract base class EasyDialogIdentifier {
  /// @nodoc
  const EasyDialogIdentifier();

  /// The identity of the dialog.
  Object get identity;
}

/// {@category Dialogs}
/// {@category Getting started}
/// Base dialog class.
///
/// This class is used as a base class.
///
/// It is useful when there is a need to describe a dialog, its properties,
/// and behaviors.
abstract base class EasyDialog
    with EasyDialogLifecycle
    implements EasyDialogIdentifier {
  late final EasyDialogContext _context;
  Widget _content;
  Object? _pendingResult;
  late final Completer<Object?> _completer;
  var _state = EasyDialogLifecycleState.created;

  /// {@macro easy_dialog_decoration}
  final EasyDialogDecoration decoration;
  EasyDialogLifecycleState get state => _state;
  EasyDialogContext get context => _context;
  Widget get content => _content;

  /// {@macro easy_dialog_animation_configuration}
  final EasyDialogAnimationConfiguration animationConfiguration;

  /// The duration until the dialog will be hidden automatically.
  ///
  /// If this is `null`, the dialog will not be automatically hidden.
  final Duration? autoHideDuration;

  /// Creates an instance of [EasyDialog].
  EasyDialog({
    required Widget content,
    this.autoHideDuration,
    this.decoration = const EasyDialogDecoration.none(),
    this.animationConfiguration =
        const EasyDialogAnimationConfiguration.bounded(),
  }) : _content = content;

  /// @nodoc
  factory EasyDialog.fullScreen({
    required Widget content,
    WillPopCallback? androidWillPop,
    EasyDialogAnimationConfiguration animationConfiguration,
    EasyDialogDecoration<EasyDialog> decoration,
    Duration? autoHideDuration,
  }) = FullScreenDialog;

  /// @nodoc
  factory EasyDialog.positioned({
    required Widget content,
    EasyDialogPosition position,
    EasyDialogAnimationConfiguration animationConfiguration,
    EasyDialogDecoration<EasyDialog> decoration,
    Duration? autoHideDuration,
  }) = PositionedDialog;

  /// @nodoc
  @factory
  @protected
  EasyOverlayBoxInsertion createInsert(Widget decorated);

  /// @nodoc
  @factory
  @protected
  EasyOverlayBoxRemoval createRemove();

  /// @nodoc
  @protected
  EasyDialog clone();

  @override
  @mustCallSuper
  @protected
  void init() {
    assert(_state == EasyDialogLifecycleState.created);
    decoration.init();
    _state = EasyDialogLifecycleState.initialized;
  }

  @override
  @mustCallSuper
  @protected
  void onShow() {
    decoration.onShow();
    _state = EasyDialogLifecycleState.showing;
  }

  @override
  @mustCallSuper
  @protected
  void onShown() {
    decoration.onShown();
    _state = EasyDialogLifecycleState.shown;
  }

  @override
  @mustCallSuper
  @protected
  void onHide() {
    decoration.onHide();
    _state = EasyDialogLifecycleState.hiding;
  }

  @override
  @mustCallSuper
  @protected
  void onHidden() {
    decoration.onHidden();
    _state = EasyDialogLifecycleState.hidden;
  }

  @override
  @mustCallSuper
  @protected
  void dispose() {
    decoration.dispose();
    _state = EasyDialogLifecycleState.disposed;
  }

  EasyOverlayBoxInsertion _createInsert() => createInsert(
        RepaintBoundary(
          child: decoration._decorate(this).content,
        ),
      );

  void _complete() => _completer.complete(_pendingResult);
}

/// Dialog lifecycle state.
enum EasyDialogLifecycleState {
  /// The dialog is created.
  created,

  /// The dialog is being initialized.
  ///
  /// Context is not available at this stage.
  initialized,

  /// The dialog is being displayed.
  showing,

  /// The dialog is displayed.
  shown,

  /// The dialog is not displayed.
  hidden,

  /// The dialog is being hidden.
  hiding,

  /// The dialog is disposed.
  disposed,
}

/// {@category Dialogs}
/// {@category Getting started}
/// Context that provides some useful methods and properties that are
/// associated with specific [EasyDialog].
class EasyDialogContext {
  final _decorations = <EasyDialogDecoration>[];
  final EasyDialogsController _controller;
  final EasyDialog _dialog;

  /// @nodoc
  EasyDialogContext._({
    required EasyDialog dialog,
    required EasyDialogsController controller,
  })  : _dialog = dialog,
        _controller = controller;

  /// @nodoc
  TickerProvider get vsync => _controller.overlay;

  /// Associated with dialog animation.
  Animation<double> get animation =>
      _controller._getAnimationController(_dialog);

  /// Hide associated dialog.
  Future<void> hideDialog({
    bool instantly = false,
    Object? result,
  }) =>
      _controller._hide(
        _dialog,
        instantly: instantly,
        result: result,
      );

  /// Get decoration of exact type.
  ///
  /// If could be useful when you need to get a decoration of a specific type to
  /// retrieve some values.
  T? getDecorationOfExactType<T extends EasyDialogDecoration>() {
    for (final d in _decorations) {
      if (d is T) return d;
    }

    return null;
  }

  T? getParentDecorationOfType<T extends EasyDialogDecoration>(
    EasyDialogDecoration child,
  ) {
    final childIndex = _decorations.indexOf(child);

    assert(childIndex != -1);

    for (var i = childIndex - 1; i >= 0; i--) {
      final decoration = _decorations[i];

      if (decoration is T) return decoration;
    }

    return null;
  }

  /// @nodoc
  void dispose() => _decorations.clear();

  void _registerDecoration<T extends EasyDialogDecoration>(T decoration) =>
      _decorations.add(decoration);
}

class _DialogEntry {
  final EasyDialog dialog;
  final AnimationController animationController;

  _DialogEntry({
    required EasyDialog dialog,
    required AnimationController animationController,
  })  : dialog = dialog,
        animationController = animationController;

  void dispose() {
    dialog._context.dispose();
    dialog.dispose();

    final needDisposeController = switch (dialog.animationConfiguration) {
      AnimationConfigurationWithController c => c.willDispose,
      _ => true,
    };

    if (needDisposeController) animationController.dispose();
  }
}

/// {@category Dialogs}
/// {@category Getting started}
/// @nodoc
extension EasyDialogsX on EasyDialog {
  /// @nodoc
  Future<T?> show<T extends Object?>() => FlutterEasyDialogs.show<T>(this);

  /// @nodoc
  Future<void> hide({
    bool instantly = false,
    Object? result,
  }) =>
      FlutterEasyDialogs.hide(
        this,
        instantly: instantly,
        result: result,
      );
}
