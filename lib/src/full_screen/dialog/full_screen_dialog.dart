import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_easy_dialogs/src/core/android_back_button_interceptor_mixin.dart';

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
  EasyOverlayBoxInsertion createInsert(Widget decorated) =>
      FullScreenDialogInsert(dialog: decorated);

  @override
  EasyOverlayBoxRemoval createRemove() => const FullScreenDialogRemove();

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
      androidWillPop: androidWillPop,
      animationConfiguration: animationConfiguration,
      decoration: decoration,
    );
  }
}

@visibleForTesting
final class FullScreenDialogInsert
    extends EasyOverlayBoxInsertion<FullScreenDialog> {
  /// @nodoc
  const FullScreenDialogInsert({required super.dialog});

  @override
  EasyOverlayEntry call(EasyDialogsOverlayBox box) {
    assert(
      box.get(super.dialogType) == null,
      'only single one full screen $EasyDialogsOverlayEntry can be presented',
    );

    final entry = EasyDialogsOverlayEntry(
      builder: (_) => dialog,
    );

    box.put(super.dialogType, entry);

    return entry;
  }
}

@visibleForTesting
final class FullScreenDialogRemove
    extends EasyOverlayBoxRemoval<FullScreenDialog> {
  /// Creates a new instance of the [FullScreenDialogRemove].
  const FullScreenDialogRemove();

  @override
  EasyOverlayEntry? call(EasyDialogsOverlayBox box) =>
      box.remove<EasyOverlayEntry>(dialogType);
}
