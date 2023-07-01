import 'dart:async';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_overlay.dart';

part 'easy_dialog_decoration.dart';
part 'easy_dialog_animation.dart';
part 'easy_dialog_dismiss.dart';

// ignore_for_file: avoid-redundant-async

/// {@category Dialog manager}
/// {@category Getting started}
/// {@category Custom}
/// This is the base class for all dialog managers.
///
/// The main idea is that any specific [EasyDialogsController]
/// is responsible for only two things: *`showing`* and *`hiding`* dialogs.
///
/// Therefore, there are two methods: [show] and [hide].
///
/// In other words, this class is responsible for managing dialogs that
/// are specific to it, including:
///
/// * Inserting and removing dialogs from [EasyDialogsOverlay].
/// * Applying any provided [EasyDialogDecoration] or multiple decorators.
final class EasyDialogsController {
  final _conversations = <Type, EasyDialogConversation>{};

  /// Creates an instance of [EasyDialogsController].
  /// [IEasyOverlay] is used for providing [Ticker]
  /// for creating animations and inserting dialogs into [EasyDialogsOverlay].
  @visibleForTesting
  final IEasyOverlay overlay;

  EasyDialogsController(this.overlay);

  /// This is an abstract [show] method with a [dialog] of type [D].
  ///
  /// This is the core method used for displaying dialogs.
  Future<T?> show<T extends Object?>(EasyDialog dialog) async {
    final conversation =
        _conversations[dialog.runtimeType] ?? _createConversation(dialog);

    return conversation.begin<T>(dialog);
  }

  /// This is an abstract [hide] method with a [options] of type [H].
  ///
  /// This is the core method used for hiding dialogs.
  Future<void> hide(
    EasyDialogHiding hide, {
    bool instantly = false,
  }) async =>
      _conversations[hide._dialogType]?.end(hide);

  void dispose() {
    _conversations.values.forEach((conversation) => conversation.dispose());
    _conversations.clear();
  }

  EasyDialogConversation _createConversation(EasyDialog dialog) {
    final conversation = dialog.createConversation();
    _conversations[dialog.runtimeType] = conversation;
    conversation._overlay = overlay;
    conversation.init();

    return conversation;
  }
}

abstract mixin class EasyDialogLifecycle {
  @protected
  void init() {}

  @protected
  void onShow() {}

  @protected
  void onShown() {}

  @protected
  void onHide() {}

  @protected
  void onHidden() {}

  @protected
  void dispose() {}
}

abstract interface class EasyDialogIdentifier {
  Object get identity;
}

abstract class EasyDialogHiding<Dialog extends EasyDialog>
    implements EasyDialogIdentifier {
  const EasyDialogHiding();

  Type get _dialogType => Dialog;
}

/// {@category Dialog manager}
/// {@category Getting started}
/// {@category Custom}
/// Base data class of show params for dialog managers.
abstract base class EasyDialog
    with EasyDialogLifecycle
    implements EasyDialogIdentifier {
  final Widget _content;
  final EasyDialogDecoration _decoration;
  late EasyDialogContext _context;
  EasyDialogContext get context => _context;

  /// Animation settings.
  final EasyDialogAnimationConfiguration animationConfiguration;

  /// The duration until the dialog will be hidden automatically.
  ///
  /// If this is `null`, the dialog will not be automatically hidden.
  final Duration? hideAfterDuration;

  /// Creates an instance of [EasyDialog].
  EasyDialog({
    required Widget content,
    this.hideAfterDuration,
    EasyDialogDecoration<EasyDialog> decoration =
        const EasyDialogDecoration.none(),
    this.animationConfiguration = const EasyDialogAnimationConfiguration(),
  })  : _decoration = decoration,
        _content = content;

  @factory
  EasyDialogConversation createConversation();
  @factory
  EasyOverlayBoxInsert createInsert();
  @factory
  EasyOverlayBoxRemove createRemove();

  @override
  @mustCallSuper
  void init() {
    _decoration.init();

    _context = _decoration._decorate(this.context);
  }

  @override
  @mustCallSuper
  void onShow() {
    _decoration.onShow();
  }

  @override
  void onShown() {
    super.onShown();
    _decoration.onShown();
  }

  @override
  void onHide() {
    super.onHide();
    _decoration.onHide();
  }

  @override
  @mustCallSuper
  void onHidden() {
    _decoration.onHidden();
  }

  @override
  @mustCallSuper
  void dispose() {
    _decoration.dispose();
    context.dispose();
  }
}

class EasyDialogContext<Dialog extends EasyDialog> {
  final List<EasyDialogDecoration<Dialog>> _decorations;
  final EasyDialogConversation _conversation;
  final Dialog dialog;
  final Widget content;

  EasyDialogContext._({
    required this.dialog,
    required this.content,
    required EasyDialogConversation conversation,
    List<EasyDialogDecoration<Dialog>>? decorations,
  })  : _conversation = conversation,
        _decorations = decorations ?? [];

  TickerProvider get vsync => _conversation._overlay;
  Animation<double> get animation =>
      _conversation.getAnimationController(dialog);

  Future<void> hideDialog({
    bool instantly = false,
    Object? result,
  }) =>
      _conversation._hide(
        dialog,
        instantly: instantly,
        result: result,
      );

  T? getDecorationOfExactType<T extends EasyDialogDecoration<Dialog>>() =>
      _decorations.firstWhereOrNull((e) => e is T) as T?;

  T? getParentDecorationOfType<T extends EasyDialogDecoration<Dialog>>(
    EasyDialogDecoration<Dialog> child,
  ) {
    final childIndex = _decorations.indexOf(child);

    assert(childIndex != -1);

    for (var i = childIndex - 1; i >= 0; i--) {
      final decoration = _decorations[i];

      if (decoration is T) return decoration;
    }

    return null;
  }

  void dispose() {
    _decorations.clear();
  }

  void _registerDecoration<T extends EasyDialogDecoration<Dialog>>(
    T decoration,
  ) =>
      _decorations.add(decoration);

  EasyDialogContext<Dialog> _updateWithContent(Widget content) =>
      EasyDialogContext<Dialog>._(
        dialog: dialog,
        content: content,
        conversation: _conversation,
        decorations: _decorations,
      );
}

class ConversationEntry<T extends Object?> {
  T? _pendingResult;

  final EasyDialog _dialog;
  final AnimationController _animationController;
  final _completer = Completer<T?>();

  ConversationEntry({
    required EasyDialog dialog,
    required AnimationController animationController,
  })  : _dialog = dialog,
        _animationController = animationController;

  void dispose() {
    _dialog.dispose();
    _animationController.dispose();
  }
}

abstract base class EasyDialogConversation<Dialog extends EasyDialog,
    Hide extends EasyDialogHiding> {
  late final IEasyOverlay _overlay;
  @visibleForTesting
  final entries = <Object, ConversationEntry>{};

  EasyDialogConversation();

  @protected
  bool checkPresented(EasyDialogIdentifier identifier) =>
      entries.containsKey(identifier.identity);

  @protected
  AnimationController getAnimationController(EasyDialogIdentifier identifier) {
    assert(
      entries.containsKey(identifier.identity),
      'dialog is not registered in this conversation',
    );

    return entries[identifier.identity]!._animationController;
  }

  @protected
  @mustCallSuper
  Future<T?> begin<T extends Object?>(Dialog dialog) async {
    final entry = _createEntry<T>(dialog);

    _overlay.insertDialog(dialog.createInsert());

    await entry._animationController.forward();

    return entry._completer.future;
  }

  @protected
  @mustCallSuper
  Future<void> end(
    Hide hide, {
    bool instantly = false,
  }) async {
    assert(hide._dialogType == Dialog);
    if (entries.isEmpty) return null;

    return _hide(hide, instantly: instantly);
  }

  @protected
  Future<void> hideAll({bool instantly = false}) => Future.wait(
        entries.values.map(
          (e) => _hide(
            e._dialog,
            instantly: instantly,
          ),
        ),
      );

  @protected
  Future<void> hide(
    EasyDialogIdentifier identifier, {
    bool instantly = false,
  }) =>
      _hide(identifier);

  @protected
  @mustCallSuper
  void init() {}

  @protected
  @mustCallSuper
  void dispose() {
    entries.values.forEach((entry) => entry.dispose());
    entries.clear();
  }

  ConversationEntry<T> _createEntry<T extends Object?>(Dialog dialog) {
    final entry = ConversationEntry<T>(
      dialog: dialog,
      animationController:
          dialog.animationConfiguration.createController(_overlay),
    );
    assert(!entries.containsKey(dialog.identity));

    entries[dialog.identity] = entry;
    dialog._context = EasyDialogContext<Dialog>._(
      dialog: dialog,
      content: dialog._content,
      conversation: this,
    );
    dialog.init();

    entry._animationController.addStatusListener(
      (status) => _animationStatusListener(status, entry),
    );

    return entry;
  }

  Future<void> _animationStatusListener(
    AnimationStatus status,
    ConversationEntry entry,
  ) async {
    final dialog = entry._dialog;
    switch (status) {
      case AnimationStatus.forward:
        dialog.onShow();
      case AnimationStatus.completed:
        dialog.onShown();

        if (dialog.hideAfterDuration == null) return;

        await Future.delayed(dialog.hideAfterDuration!);

        if (entry._animationController.isDismissed) return;

        await entry._animationController.reverse();
      case AnimationStatus.reverse:
        dialog.onHide();
      case AnimationStatus.dismissed:
        assert(
          identical(
            entries[dialog.identity]?._animationController,
            entry._animationController,
          ),
        );

        entry._dialog.onHidden();

        entry._completer.complete(entry._pendingResult);

        _releaseEntry(entry);
    }
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
    entry._pendingResult = result;

    instantly
        ? entry._animationController.value = 0.0
        : await entry._animationController.reverse();

    await entry._completer.future;
  }

  void _releaseEntry(ConversationEntry entry) {
    assert(
      identical(
        entries[entry._dialog.identity]?._animationController,
        entry._animationController,
      ),
    );
    assert(entry._completer.isCompleted);

    entries.remove(entry._dialog.identity);
    _overlay.removeDialog(entry._dialog.createRemove());
    entry.dispose();
  }
}

abstract base class SingleDialogConversation<Dialog extends EasyDialog,
        Hide extends EasyDialogHiding>
    extends EasyDialogConversation<Dialog, Hide> {
  SingleDialogConversation();

  @protected
  bool get isPresented => entries.isNotEmpty;

  @override
  Future<T?> begin<T extends Object?>(Dialog dialog) async {
    if (entries.isNotEmpty)
      await entries.values.first._animationController.reverse();

    return super.begin<T>(dialog);
  }

  @override
  void dispose() {
    assert(entries.length <= 1);

    super.dispose();
  }
}

extension EasyDialogsX on EasyDialog {
  Future<T?> show<T extends Object?>() => FlutterEasyDialogs.show(this);

  Future<void> hide({
    bool instantly = false,
    Object? result,
  }) =>
      context.hideDialog(
        instantly: instantly,
        result: result,
      );
}
