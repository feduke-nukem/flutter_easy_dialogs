import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animation_configuration.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
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
  @mustCallSuper
  void init() {}

  @protected
  @mustCallSuper
  void onShow() {}

  @protected
  @mustCallSuper
  void onHide() {}

  @protected
  @mustCallSuper
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
  /// Creates an instance of [EasyDialog].
  EasyDialog({
    required Widget child,
    List<EasyDialogDecorator> shells = const <EasyDialogDecorator>[],
    List<EasyDialogDecorator> animators = const <EasyDialogDecorator>[],
    List<EasyDialogDecorator> dismissibles = const <EasyDialogDecorator>[],
    this.animationConfiguration = const EasyDialogAnimationConfiguration(),
  })  : _child = child,
        _decorators =
            shells.followedBy(animators).followedBy(dismissibles).toList();

  final List<EasyDialogDecorator> _decorators;
  EasyDialogConversation? _conversation;

  /// Content for showing.
  final Widget _child;
  Widget? _decoratedChild;
  Widget get child => _decoratedChild ?? _child;

  @override
  Object get identity;

  @protected
  EasyConversationContext get context {
    assert(_conversation != null);

    return _conversation!;
  }

  Animation<double> get animation => context.animationOf(this);

  /// Animator settings.
  final EasyDialogAnimationConfiguration animationConfiguration;

  @factory
  EasyDialogConversation createConversation();
  @factory
  EasyOverlayBoxInsert createInsert();
  EasyOverlayBoxRemove createRemove();
  Future<void> requestHide({bool instantly = false}) =>
      _conversation!._hideByIdentifier(this, instantly: instantly);

  @override
  @mustCallSuper
  void init() {
    super.init();
    _decorators.forEach((decorator) => decorator.init());

    for (var decorator in _decorators) {
      _decoratedChild = decorator(this);
    }
  }

  @override
  @mustCallSuper
  void onShow() {
    super.onShow();
    _decorators.forEach((decorator) => decorator.onShow());
  }

  @override
  @mustCallSuper
  void onHide() {
    super.onHide();
    _decorators.forEach((decorator) => decorator.onHide());
  }

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    _decorators.forEach((decorator) => decorator.dispose());
    _decorators.clear();
    _decoratedChild = null;
  }
}

abstract class EasyDialogHide<Dialog extends EasyDialog>
    implements EasyDialogIdentifier {
  const EasyDialogHide();

  Type get _dialogType => Dialog;

  @override
  Object get identity;
}

abstract interface class EasyConversationContext {
  TickerProvider get vsync;
  Animation<double> animationOf(EasyDialogIdentifier identifier);
  bool checkPresented(EasyDialogIdentifier identifier);
  BuildContext get overlayContext;
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
  @visibleForTesting
  final entries = <Object, ConversationEntry>{};

  @override
  BuildContext get overlayContext => _overlay.context;

  @override
  Animation<double> animationOf(EasyDialogIdentifier identifier) {
    final animation = entries[identifier.identity]?.animationController;
    assert(animation != null, 'dialog is not registered in this conversation');

    return animation!;
  }

  @override
  bool checkPresented(EasyDialogIdentifier identifier) =>
      entries.containsKey(identifier.identity);

  Future<void> _hideByIdentifier(
    EasyDialogIdentifier identifier, {
    bool instantly = false,
  }) async {
    final entry = entries[identifier.identity];
    assert(entry != null, 'dialog is not registered in this conversation');

    if (instantly) {
      entry!.animationController.value = 0.0;

      return;
    }

    return entry!.animationController.reverse();
  }

  @protected
  AnimationController getControllerOf(EasyDialogIdentifier identifier) =>
      entries[identifier.identity]!.animationController;

  @mustCallSuper
  Future<void> begin(Dialog dialog) async {
    final animationController = _createAnimationController(dialog);

    _overlay.insertDialog(dialog.createInsert());

    dialog.onShow();

    return animationController.forward();
  }

  @override
  TickerProvider get vsync => _overlay;

  @mustCallSuper
  Future<void> end(Hide hide) async {
    assert(hide._dialogType == Dialog);
    if (entries.isEmpty) return;

    _hideByIdentifier(hide);
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
      dialog,
      dialog.animationConfiguration.createController(_overlay),
    );
    assert(!entries.containsKey(dialog.identity));
    entries[dialog.identity] = entry;
    dialog._conversation = this;
    dialog.init();

    entry.animationController.addStatusListener(
      (status) {
        if (status != AnimationStatus.dismissed) return;

        assert(identical(entries[dialog.identity], entry));

        entry.dialog.onHide();

        _releaseEntry(entry);
      },
    );

    return entry.animationController;
  }

  void _releaseEntry(ConversationEntry entry) {
    assert(identical(entries[entry.dialog.identity], entry));

    entries.remove(entry.dialog.identity);
    _overlay.removeDialog(entry.dialog.createRemove());
    entry.dispose();
    entry.dialog._conversation = null;
  }
}

base mixin EasyDialogHiderMixin<Dialog extends EasyDialog,
    Hide extends EasyDialogHide> on EasyDialogConversation<Dialog, Hide> {
  Future<void> hideAll({bool instantly = false}) => Future.wait(
        entries.values.where((entry) => entry.dialog is Dialog).map(
              (e) => super._hideByIdentifier(e.dialog),
            ),
      );

  Future<void> hide(
    EasyDialogIdentifier identifier, {
    bool instantly = false,
  }) =>
      super._hideByIdentifier(identifier);
}

abstract base class SingleDialogConversation<Dialog extends EasyDialog,
    Hide extends EasyDialogHide> extends EasyDialogConversation<Dialog, Hide> {
  SingleDialogConversation();

  @protected
  bool get isPresented => entries.isNotEmpty;

  @override
  Future<void> begin(Dialog dialog) async {
    if (entries.isNotEmpty)
      await entries.values.first.animationController.reverse();

    return super.begin(dialog);
  }

  @override
  void dispose() {
    assert(entries.length <= 1);

    super.dispose();
  }
}
