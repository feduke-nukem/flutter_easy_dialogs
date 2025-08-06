import 'dart:async';

import 'package:flutter_easy_dialogs/src/core/android_back_button_interceptor_mixin.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';

typedef FullScreenWillPopCallback = FutureOr<bool> Function();

/// Dialog that is intended to cover the entire screen.
final class FullScreenDialog extends EasyDialog
    with AndroidBackButtonInterceptorMixin {
  static const defaultId = '\$fullScreenDialog';

  static const defaultAnimationConfiguration =
      EasyDialogAnimationConfiguration.bounded(
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 300),
  );

  /// Callback that is invoked when the user presses the back button on Android.
  final FullScreenWillPopCallback? androidWillPop;

  /// Creates an instance of [FullScreenDialog].
  FullScreenDialog({
    required super.content,
    super.id = defaultId,
    this.androidWillPop,
    super.animationConfiguration = defaultAnimationConfiguration,
    super.decoration,
    super.autoHideDuration,
  });

  @override
  Future<void> onAndroidPop() async {
    if (androidWillPop == null) return;

    final canPop = await androidWillPop!();

    if (!canPop) return;

    this.context.hideDialog(
          result: context
              .getDecorationOfExactType<EasyDialogDismiss>()
              ?.onDismissed
              ?.call(),
        );
  }

  @override
  EasyDialog clone() {
    return FullScreenDialog(
      content: content,
      id: id,
      androidWillPop: androidWillPop,
      animationConfiguration: animationConfiguration,
      decoration: decoration,
      autoHideDuration: autoHideDuration,
    );
  }
}
