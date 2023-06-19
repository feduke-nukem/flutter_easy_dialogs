import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/handle_android_back_button_mixin.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/full_screen_background_animator/full_screen_background_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/full_screen_foreground_animator/full_screen_foreground_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dismissible/full_screen_dismissible.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dialog/full_screen_dialog_conversation.dart';
import 'package:flutter_easy_dialogs/src/full_screen/shell/full_screen_dialog_shell.dart';

const _defaultDuration = Duration(milliseconds: 300);
const _defaultReverseDuration = Duration(milliseconds: 300);

/// Show params for [FullScreenConversation].
final class FullScreenDialog extends EasyDialog
    with HandleAndroidBackButtonMixin {
  /// Creates an instance of [FullScreenDialog].
  FullScreenDialog({
    required super.child,
    this.willPop,
    super.animationConfiguration = const EasyDialogAnimationConfiguration(
      duration: _defaultDuration,
      reverseDuration: _defaultReverseDuration,
    ),
    super.shells = const [FullScreenDialogShell.modalBanner()],
    super.animators = const [
      FullScreenForegroundAnimator.bounce(),
      FullScreenBackgroundAnimator.blur(),
    ],
    super.dismissibles = const [FullScreenDismissible.tap()],
  });

  static FullScreenHide hide() => const FullScreenHide();

  @override
  FullScreenDialogConversation createConversation() =>
      FullScreenDialogConversation();

  @override
  Object get identity => runtimeType;

  @override
  EasyOverlayBoxInsert<EasyDialog> createInsert() =>
      FullScreenDialogInsert(dialog: child);

  @override
  EasyOverlayBoxRemove<EasyDialog> createRemove() =>
      const FullScreenDialogRemove();

  @override
  final WillPopCallback? willPop;

  @override
  void onPop() {
    super.requestHide();
  }
}

class FullScreenHide extends EasyDialogHide<FullScreenDialog> {
  const FullScreenHide();

  @override
  Object get identity => FullScreenDialog;
}
