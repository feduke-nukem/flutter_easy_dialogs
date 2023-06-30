import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animation_configuration.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decoration.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_overlay.dart';

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
  Future<T?> show<T>(EasyDialog dialog) async {
    final conversation =
        _conversations[dialog.runtimeType] ?? _createConversation(dialog);

    return conversation.begin<T>(dialog);
  }

  /// This is an abstract [hide] method with a [options] of type [H].
  ///
  /// This is the core method used for hiding dialogs.
  Future<void> hide(EasyDialogHiding hide) async =>
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
  void onHide() {}

  @protected
  void dispose() {}
}

abstract interface class EasyDialogIdentifier {
  Object get identity;
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

  late final EasyDialogContext context;

  /// Animation settings.
  final EasyDialogAnimationConfiguration animationConfiguration;

  /// Creates an instance of [EasyDialog].
  EasyDialog({
    required Widget content,
    EasyDialogDecoration<EasyDialog> decoration =
        const EasyDialogDecoration.none(),
    this.animationConfiguration = const EasyDialogAnimationConfiguration(),
  })  : _decoration = decoration,
        _content = content;

  @factory
  EasyDialogConversation createConversation();
  @factory
  EasyOverlayBoxInsert createInsert(Widget content);
  @factory
  EasyOverlayBoxRemove createRemove();

  EasyOverlayBoxInsert _createInsert() => createInsert(
        _decoration(this, this._content),
      );

  @override
  @mustCallSuper
  void init() {
    _decoration.init();
  }

  @override
  @mustCallSuper
  void onShow() {
    _decoration.onShow();
  }

  @override
  @mustCallSuper
  void onHide() {
    _decoration.onHide();
  }

  @override
  @mustCallSuper
  void dispose() {
    _decoration.dispose();
  }
}

abstract class EasyDialogHiding<Dialog extends EasyDialog>
    implements EasyDialogIdentifier {
  const EasyDialogHiding();

  Type get _dialogType => Dialog;
}

class EasyDialogContext {
  final EasyDialogConversation _conversation;
  Widget _content;
  final EasyDialog dialog;
  Widget get content => _content;

  EasyDialogContext._({
    required EasyDialog dialog,
    required EasyDialogConversation conversation,
  })  : dialog = dialog,
        _conversation = conversation,
        _content = dialog._content;

  EasyDialogContext._fromContent({
    required EasyDialog dialog,
    required EasyDialogConversation conversation,
    required Widget content,
  })  : _content = content,
        dialog = dialog,
        _conversation = conversation;

  TickerProvider get vsync => _conversation._overlay;
  Animation<double> get animation => _conversation._getAnimation(dialog);
  Future<void> hide<T>({
    bool instantly = false,
    T? result,
  }) =>
      _conversation._hide<T>(
        dialog,
        instantly: instantly,
        result: result,
      );

  void updateContent(Widget content) {
    _content = content;

    // return EasyDialogContext._fromContent(
    //   dialog: dialog,
    //   conversation: _conversation,
    //   content: content,
    // );
  }
}

class ConversationEntry<T> {
  T? _result = null;
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

  Animation<double> _getAnimation(EasyDialogIdentifier identifier) {
    final animation = entries[identifier.identity]?._animationController;
    assert(animation != null, 'dialog is not registered in this conversation');

    return animation!;
  }

  @protected
  bool checkPresented(EasyDialogIdentifier identifier) =>
      entries.containsKey(identifier.identity);

  @protected
  AnimationController getAnimationController(EasyDialogIdentifier identifier) {
    assert(entries.containsKey(identifier.identity));

    return entries[identifier.identity]!._animationController;
  }

  @protected
  @mustCallSuper
  Future<T?> begin<T>(Dialog dialog) async {
    final entry = _createEntry<T>(dialog);

    _overlay.insertDialog(dialog._createInsert());

    dialog.onShow();

    await entry._animationController.forward();

    return entry._completer.future;
  }

  @protected
  @mustCallSuper
  Future<void> end(Hide hide) async {
    assert(hide._dialogType == Dialog);
    if (entries.isEmpty) return null;

    return _hide(hide);
  }

  @protected
  Future<void> hideAll({bool instantly = false}) => Future.wait(
        entries.values.where((entry) => entry._dialog is Dialog).map(
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

  ConversationEntry<T> _createEntry<T>(Dialog dialog) {
    final entry = ConversationEntry<T>(
      dialog: dialog,
      animationController:
          dialog.animationConfiguration.createController(_overlay),
    );
    assert(!entries.containsKey(dialog.identity));
    entries[dialog.identity] = entry;
    dialog.context = EasyDialogContext._(
      dialog: dialog,
      conversation: this,
    );
    dialog.init();

    entry._animationController.addStatusListener(
      (status) {
        if (status != AnimationStatus.dismissed) return;

        assert(
          identical(
            entries[dialog.identity]?._animationController,
            entry._animationController,
          ),
        );

        entry._dialog.onHide();

        entry._completer.complete(entry._result);

        _releaseEntry(entry);
      },
    );

    return entry;
  }

  Future<void> _hide<T>(
    EasyDialogIdentifier identifier, {
    bool instantly = false,
    T? result,
  }) async {
    assert(entries[identifier.identity] != null,
        'dialog is not registered in this conversation');
    assert(entries[identifier.identity] is ConversationEntry<T>);

    final entry = entries[identifier.identity] as ConversationEntry<T>;
    entry._result = result;

    if (instantly) {
      entry._animationController.value = 0.0;

      await entry._completer.future;

      return;
    }

    await entry._animationController.reverse();

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
  Future<T?> begin<T>(Dialog dialog) async {
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
