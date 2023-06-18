import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animation_configuration.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';
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
/// * Applying any provided [EasyDialogDecorator] or multiple decorators.
final class EasyDialogsController {
  /// Creates an instance of [EasyDialogsController].
  EasyDialogsController(this.overlay);

  final _conversations = <Type, EasyDialogConversation>{};

  /// [IEasyOverlay] is used for providing [Ticker]
  /// for creating animations and inserting dialogs into [EasyDialogsOverlay].
  @visibleForTesting
  final IEasyOverlay overlay;

  /// This is an abstract [show] method with a [dialog] of type [D].
  ///
  /// This is the core method used for displaying dialogs.
  Future<void> show(EasyDialog dialog) {
    final conversation =
        _conversations[dialog.runtimeType] ?? _createConversation(dialog);

    return conversation.begin(dialog);
  }

  /// This is an abstract [hide] method with a [options] of type [H].
  ///
  /// This is the core method used for hiding dialogs.
  Future<void> hide(EasyDialogHide hide) async =>
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

/// {@category Dialog manager}
/// {@category Getting started}
/// {@category Custom}
/// Base data class of show params for dialog managers.
abstract base class EasyDialog with EasyDialogLifecycle {
  /// Creates an instance of [EasyDialog].
  EasyDialog({
    required this.child,
    this.shells = const <EasyDialogDecorator>[],
    this.animators = const <EasyDialogDecorator>[],
    this.dismissibles = const <EasyDialogDecorator>[],
    this.animationConfiguration = const EasyDialogAnimationConfiguration(),
  }) : _decorators =
            shells.followedBy(animators).followedBy(dismissibles).toList();

  final List<EasyDialogDecorator> _decorators;
  EasyDialogConversation? _conversation;

  /// Content for showing.
  final Widget child;

  final List<EasyDialogDecorator> shells;
  final List<EasyDialogDecorator> animators;
  final List<EasyDialogDecorator> dismissibles;

  Object get identifier;

  EasyConversationContext get context {
    assert(_conversation != null);

    return _conversation!;
  }

  Animation<double> get animation => context.animationOf(this);
  DismissHandler get dismissHandler => context.dismissHandlerOf(this);

  /// Animator settings.
  final EasyDialogAnimationConfiguration animationConfiguration;

  void _takeConversationFrom(EasyDialog other) {
    assert(_conversation == null && other._conversation != null);
    assert(this.runtimeType == other.runtimeType);
    assert(this.identifier == other.identifier);

    other._conversation!._replaceDialog(this);
  }

  @factory
  EasyDialogConversation createConversation();
  @factory
  EasyOverlayBoxInsert createInsert(Widget decorated);
  EasyOverlayBoxRemove createRemove();

  @override
  @mustCallSuper
  void init() {
    _decorators.forEach((decorator) => decorator.init());
  }

  @override
  @mustCallSuper
  void onShow() {
    _decorators.forEach((decorator) => decorator.onShow());
  }

  @override
  @mustCallSuper
  void onHide() {
    _decorators.forEach((decorator) => decorator.onHide());
  }

  @override
  @mustCallSuper
  void dispose() {
    _decorators.forEach((decorator) => decorator.dispose());
  }

  EasyOverlayBoxInsert _createInsert() => createInsert(
        EasyDialogDecorator.combine(_decorators).call(this).child,
      );
}

abstract class EasyDialogHide<Dialog extends EasyDialog> {
  const EasyDialogHide();

  Type get _dialogType => Dialog.runtimeType;
  Object get identifier;
}

abstract interface class EasyConversationContext {
  TickerProvider get vsync;
  Animation<double> animationOf(EasyDialog dialog);
  bool checkPresented(EasyDialog dialog);
  DismissHandler dismissHandlerOf(EasyDialog dialog);
}

class ConversationEntry {
  ConversationEntry(this.dialog, this.animationController);

  final EasyDialog dialog;
  final AnimationController animationController;

  void dispose() {
    dialog.dispose();
    animationController.dispose();
  }
}

abstract base class EasyDialogConversation<Dialog extends EasyDialog,
    Hide extends EasyDialogHide> implements EasyConversationContext {
  EasyDialogConversation();

  late final IEasyOverlay _overlay;
  @protected
  final entries = <Object, ConversationEntry>{};

  @override
  Animation<double> animationOf(EasyDialog dialog) {
    final animation = entries[dialog.identifier]?.animationController;
    assert(animation != null, 'dialog is not registered in this conversation');

    return animation!;
  }

  @override
  bool checkPresented(EasyDialog dialog) =>
      entries.containsKey(dialog.identifier);

  @override
  @nonVirtual
  DismissHandler dismissHandlerOf(EasyDialog dialog) {
    final entry = entries[dialog.identifier];
    assert(entry != null, 'dialog is not registered in this conversation');

    return (payload) => handleDismiss(
          payload,
          entry!,
        );
  }

  @protected
  @mustCallSuper
  Future<void> handleDismiss(
    EasyDismissiblePayload payload,
    ConversationEntry entry,
  ) =>
      releaseEntry(
        entry,
        animate: !payload.instantDismiss,
      );

  @mustCallSuper
  Future<void> begin(Dialog dialog) async {
    // await _removeDialogIfExists(dialog);
    final animationController = _createAnimationController(dialog);

    _overlay.insertDialog(dialog._createInsert());

    dialog.onShow();

    return animationController.forward();
  }

  @override
  TickerProvider get vsync => _overlay;

  void _replaceDialog(EasyDialog dialog) {
    final entry = entries[dialog.identifier];
    assert(entry != null, 'dialog is not registered in this conversation');

    dialog._conversation = this;
    entries[dialog.identifier] = ConversationEntry(
      dialog,
      entry!.animationController,
    );
  }

  @mustCallSuper
  Future<void> end(Hide hide) async {
    assert(hide._dialogType == Dialog.runtimeType);
    if (entries.isEmpty) return;

    final entry = entries[hide.identifier];
    assert(entry != null || entries.length == 1);

    await releaseEntry(entry ?? entries.values.first, animate: true);
  }

  @mustCallSuper
  void init() {}

  @mustCallSuper
  void dispose() {
    entries.values.forEach((entry) => entry.dispose());
    entries.clear();
  }

  AnimationController _createAnimationController(Dialog dialog) {
    final entry = ConversationEntry(
      dialog..init(),
      dialog.animationConfiguration.createController(_overlay),
    );
    entries[dialog.identifier] = entry;
    dialog._conversation = this;

    entry.animationController.addStatusListener(
      (status) async {
        if (status != AnimationStatus.dismissed) return;

        final shouldRelease = identical(entries[dialog.identifier], entry);

        if (!shouldRelease) return;

        await releaseEntry(entry, animate: false);
      },
    );

    return entry.animationController;
  }

  // Future<void> _removeDialogIfExists(Dialog dialog) async {
  //   final entry = entries[dialog.identifier];

  //   if (entry == null) return;

  //   await releaseEntry(entry, animate: true);
  // }

  @protected
  @mustCallSuper
  Future<void> releaseEntry(
    ConversationEntry entry, {
    required bool animate,
  }) async {
    entries.remove(entry.dialog.identifier);
    if (animate) {
      entry.dialog.onHide();
      await entry.animationController.reverse();
    }
    _overlay.removeDialog(entry.dialog.createRemove());
    entry.dialog._conversation = null;
    entry.dispose();
  }

  @protected
  Future<void> releaseAll({required bool animate}) {
    final tasks = entries.entries.map<Future<void>>(
      (e) => releaseEntry(e.value, animate: animate),
    );

    return Future.wait(tasks);
  }
}

abstract base class SingleDialogConversation<Dialog extends EasyDialog,
    Hide extends EasyDialogHide> extends EasyDialogConversation<Dialog, Hide> {
  SingleDialogConversation();

  @protected
  bool get isPresented => entries.isNotEmpty;

  @override
  Future<void> begin(Dialog dialog) async {
    if (entries.isNotEmpty)
      await super.releaseEntry(
        entries.values.first,
        animate: true,
      );

    return super.begin(dialog);
  }

  @override
  void dispose() {
    assert(entries.length <= 1);

    super.dispose();
  }
}

final class ManyDecorators extends EasyDialogDecorator {
  const ManyDecorators(this.decorators)
      : assert(decorators.length > 0, 'decorators should not be empty');

  final Iterable<EasyDialogDecorator> decorators;

  @override
  EasyDialog call(EasyDialog dialog) {
    var result = dialog;

    for (final decorator in decorators) {
      result = decorator(result);
    }

    return result.._takeConversationFrom(dialog);
  }
}
