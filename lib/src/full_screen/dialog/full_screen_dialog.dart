import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/full_screen_background_animator/full_screen_background_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/animation/full_screen_foreground_animator/full_screen_foreground_animator.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dismissible/full_screen_dismissible.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dialog/full_screen_dialog_conversation.dart';
import 'package:flutter_easy_dialogs/src/full_screen/shell/full_screen_dialog_shell.dart';

const _defaultDuration = Duration(milliseconds: 300);
const _defaultReverseDuration = Duration(milliseconds: 300);

/// Show params for [FullScreenConversation].
final class FullScreenDialog extends EasyDialog {
  /// Creates an instance of [FullScreenDialog].
  FullScreenDialog({
    required super.child,
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
  Object get identifier => runtimeType;

  @override
  EasyOverlayBoxInsert<EasyDialog> createInsert(Widget decorated) =>
      FullScreenDialogInsert(dialog: decorated);

  @override
  EasyOverlayBoxRemove<EasyDialog> createRemove() =>
      const FullScreenDialogRemove();

  FullScreenDialog copyWith({
    Widget? child,
    List<EasyDialogDecorator>? baseDecorators,
    List<EasyDialogAnimator>? animators,
    List<EasyDialogDismissible>? dismissibles,
    EasyDialogAnimationConfiguration? animationConfiguration,
  }) {
    return FullScreenDialog(
      animationConfiguration:
          animationConfiguration ?? this.animationConfiguration,
      shells: baseDecorators ?? this.shells,
      animators: animators ?? this.animators,
      dismissibles: dismissibles ?? this.dismissibles,
      child: child ?? this.child,
    );
  }
}

class FullScreenHide extends EasyDialogHide<FullScreenDialog> {
  const FullScreenHide();

  @override
  Object get identifier => FullScreenDialog;
}
