import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/handle_android_back_button_mixin.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/full_screen_background_animator/full_screen_background_animation.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/full_screen_foreground_animator/full_screen_foreground_animation.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dismissible/full_screen_dismiss.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dialog/full_screen_dialog_conversation.dart';
import 'package:flutter_easy_dialogs/src/full_screen/shell/full_screen_dialog_shell.dart';

const _defaultDuration = Duration(milliseconds: 300);
const _defaultReverseDuration = Duration(milliseconds: 300);
const _identity = '\$fullScreenDialog';

/// Show params for [FullScreenConversation].
final class FullScreenDialog extends EasyDialog
    with HandleAndroidBackButtonMixin {
  static const defaultShell = FullScreenDialogShell.modalBanner();
  static const defaultAnimation = EasyDialogDecoration.chain(
    FullScreenForegroundAnimation.bounce(),
    FullScreenBackgroundAnimation.blur(),
  );
  static const defaultDismissible = FullScreenDismiss.tap();

  @override
  final WillPopCallback? willPop;

  /// Creates an instance of [FullScreenDialog].
  FullScreenDialog({
    required super.content,
    this.willPop,
    super.animationConfiguration = const EasyDialogAnimationConfiguration(
      duration: _defaultDuration,
      reverseDuration: _defaultReverseDuration,
    ),
    super.decoration = const EasyDialogDecoration.combine([
      defaultShell,
      defaultAnimation,
      defaultDismissible,
    ]),
  });

  @factory
  static FullScreenHiding createHiding() => const FullScreenHiding();

  @override
  FullScreenDialogConversation createConversation() =>
      FullScreenDialogConversation();

  @override
  String get identity => _identity;

  @override
  EasyOverlayBoxInsert<EasyDialog> createInsert(Widget content) =>
      FullScreenDialogInsert(dialog: content);

  @override
  EasyOverlayBoxRemove<EasyDialog> createRemove() =>
      const FullScreenDialogRemove();

  @override
  Future<void> onPop() async {
    if (willPop == null) return;

    final canPop = await willPop!();

    if (!canPop) return;

    context.hide();
  }
}

class FullScreenHiding extends EasyDialogHiding<FullScreenDialog> {
  const FullScreenHiding();

  @override
  String get identity => _identity;
}
