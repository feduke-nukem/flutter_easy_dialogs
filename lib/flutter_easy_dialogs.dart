library flutter_easy_dialogs;

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';

import 'src/overlay/easy_dialogs_overlay.dart';

export 'src/full_screen/animation/full_screen_background_animator/full_screen_background_animator.dart'
    show FullScreenBackgroundAnimator;
export 'src/full_screen/animation/full_screen_foreground_animator/full_screen_foreground_animator.dart'
    show FullScreenForegroundAnimator;
export 'src/full_screen/dismissible/full_screen_dismissible.dart'
    show FullScreenDismissible;
export 'src/full_screen/manager/full_screen_show_params.dart';
export 'src/full_screen/manager/full_screen_hide_params.dart';
export 'src/full_screen/widgets/easy_full_screen_blur.dart';
export 'src/full_screen/widgets/easy_full_screen_blur_transition.dart';
export 'src/full_screen/widgets/full_screen_dialog_shell/full_screen_dialog_shell.dart'
    show FullScreenDialogShell;
export 'src/positioned/animation/positioned_animator.dart'
    show PositionedAnimator, PositionedAnimatorData;
export 'src/custom/manager/strategy.dart'
    show CustomDialogInsertStrategy, CustomDialogRemoveStrategy;
export 'src/common/managers/mixin/block_android_back_button_mixin.dart';
export 'src/common/managers/mixin/single_auto_disposal_controller_mixin.dart';
export 'src/core/easy_dialog_animator.dart' show EasyDialogAnimator;
export 'src/core/easy_dialog_manager.dart' hide EasyDialogManager;
export 'src/core/i_easy_dialogs_controller.dart';
export 'src/core/easy_dialog_dismissible.dart'
    show EasyDialogDismissible, EasyDismissibleData;
export 'src/positioned/easy_dialog_position.dart';
export 'src/positioned/manager/positioned_hide_params.dart';
export 'src/positioned/manager/positioned_show_params.dart';
export 'src/positioned/dismissible/positioned_dismissible.dart'
    show PositionedDismissible;
export 'src/core/i_easy_overlay_controller.dart'
    show
        IEasyOverlayController,
        IEasyDialogsOverlayBox,
        EasyOverlayBoxInsert,
        EasyOverlayEntry,
        EasyOverlayBoxRemove;
export 'src/custom/manager/custom_dialog_manager.dart';
export 'src/positioned/widgets/positioned_dialog_shell/positioned_dialog_shell.dart'
    show PositionedDialogShell, PositionedDialogShellData;
export 'src/core/easy_dialog_animator_configuration.dart';

/// Wrapper for providing an easy use of different custom dialogs.
class FlutterEasyDialogs extends StatelessWidget {
  final CustomManagerBuilder? customManagerBuilder;

  /// Child widget.
  final Widget child;

  /// Creates an instance of [FlutterEasyDialogs].
  const FlutterEasyDialogs({
    required this.child,
    this.customManagerBuilder,
    super.key,
  });

  static final _key = GlobalKey<EasyDialogsOverlayState>();

  /// Gets [IEasyDialogsController].
  static IEasyDialogsController get controller =>
      _key.currentState!.easyDialogsController;

  /// For using in [MaterialApp.builder].
  static const builder = _builder;

  static TransitionBuilder _builder({
    CustomManagerBuilder? customManagerBuilder,
  }) {
    return (context, child) => FlutterEasyDialogs(
          customManagerBuilder: customManagerBuilder,
          child: child ?? const SizedBox.shrink(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: EasyDialogsOverlay(
        initialEntries: [EasyOverlayAppEntry(builder: (context) => child)],
        customManagersBuilder: customManagerBuilder,
        key: _key,
      ),
    );
  }
}
