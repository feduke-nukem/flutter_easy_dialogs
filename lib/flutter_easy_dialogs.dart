library flutter_easy_dialogs;

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';

import 'src/overlay/easy_overlay.dart';

export 'src/full_screen/animation/easy_full_screen_background_animator/easy_full_screen_background_animator.dart'
    show EasyFullScreenBackgroundAnimator;
export 'src/full_screen/animation/easy_full_screen_foreground_animator/easy_full_screen_foreground_animator.dart'
    show EasyFullScreenForegroundAnimator;
export 'src/full_screen/dismissible/easy_full_screen_dismissible.dart'
    show EasyFullScreenDismissible;
export 'src/full_screen/manager/full_screen_show_params.dart';
export 'src/full_screen/manager/full_screen_hide_params.dart';
export 'src/full_screen/widgets/easy_full_screen_blur.dart';
export 'src/full_screen/widgets/easy_full_screen_blur_transition.dart';
export 'src/full_screen/widgets/easy_full_screen_dialog_shell/easy_full_screen_dialog_shell.dart'
    show EasyFullScreenDialogShell, EasyFullScreenScopeData;
export 'src/full_screen/animation/deprecated/easy_full_screen_background_animation_type.dart';
export 'src/full_screen/animation/deprecated/easy_fullscreen_content_animation_type.dart';
export 'src/positioned/animation/easy_positioned_animator.dart'
    show EasyPositionedAnimator;
export 'src/positioned/deprecated/easy_positioned_animation_type.dart';
export 'src/positioned/deprecated/easy_positioned_dismissible_type.dart';
export 'src/custom/manager/strategy.dart'
    show CustomDialogInsertStrategy, CustomDialogRemoveStrategy;
export 'src/common/managers/mixin/block_android_back_button_mixin.dart';
export 'src/common/managers/mixin/single_auto_disposal_controller_mixin.dart';
export 'src/core/easy_animator.dart' show IEasyAnimator, EasyAnimator;
export 'src/core/easy_dialog_manager.dart';
export 'src/core/i_easy_dialogs_controller.dart';
export 'src/core/easy_dismissible.dart' show EasyDismissible, IEasyDismissible;
export 'src/positioned/easy_dialog_position.dart';
export 'src/positioned/manager/positioned_hide_params.dart';
export 'src/positioned/manager/positioned_show_params.dart';
export 'src/positioned/dismissible/easy_positioned_dismissible.dart'
    show EasyPositionedDismissible;
export 'src/core/i_easy_overlay_controller.dart'
    show
        IEasyOverlayController,
        IEasyOverlayBox,
        EasyOverlayBoxInsert,
        EasyOverlayEntry,
        EasyOverlayBoxRemove;
export 'src/custom/manager/custom_manager.dart';
export 'src/positioned/widgets/easy_positioned_dialog_shell/easy_positioned_dialog_shell.dart'
    show EasyPositionedDialogShell, EasyPositionedScopeData;
export 'src/core/widgets/easy_dialog_scope.dart';
export 'src/util/easy_dialog_scope_x.dart';
export 'src/core/easy_animation_configuration.dart';

// Service - helper for easy use different custom dialogs
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

  static final _key = GlobalKey<EasyOverlayState>();

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
      child: EasyOverlay(
        initialEntries: [EasyOverlayAppEntry(builder: (context) => child)],
        customManagersBuilder: customManagerBuilder,
        key: _key,
      ),
    );
  }
}
