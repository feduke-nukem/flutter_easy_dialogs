import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/android_back_button_interceptor_mixin.dart';
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
    with AndroidBackButtonInterceptorMixin {
  static const defaultShell = FullScreenDialogShell.modalBanner();
  static const defaultAnimation = EasyDialogDecoration<FullScreenDialog>.chain(
    FullScreenForegroundAnimation.bounce(),
    FullScreenBackgroundAnimation.blur(),
  );
  static const defaultDismissible = FullScreenDismiss.tap();
  final WillPopCallback? androidWillPop;

  /// Creates an instance of [FullScreenDialog].
  FullScreenDialog({
    required super.content,
    this.androidWillPop,
    super.animationConfiguration = const EasyDialogAnimationConfiguration(
      duration: _defaultDuration,
      reverseDuration: _defaultReverseDuration,
    ),
    super.decoration = const EasyDialogDecoration<FullScreenDialog>.combine([
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
  EasyOverlayBoxInsert<EasyDialog> createInsert() =>
      FullScreenDialogInsert(dialog: context.content);

  @override
  EasyOverlayBoxRemove<EasyDialog> createRemove() =>
      const FullScreenDialogRemove();

  @override
  Future<void> onAndroidPop() async {
    if (androidWillPop == null) return;

    final canPop = await androidWillPop!();

    if (!canPop) return;

    this.context.hideDialog();
  }
}

class FullScreenHiding extends EasyDialogHiding<FullScreenDialog> {
  const FullScreenHiding();

  @override
  String get identity => _identity;
}
