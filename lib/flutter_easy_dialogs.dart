library flutter_easy_dialogs;

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/flutter_easy_dialogs/easy_dialogs_controller.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';

export 'src/core/animations/animations.dart' hide EasyAnimationSettings;
export 'src/core/dialogs/dialogs.dart';
export 'src/core/dialogs/easy_modal_banner/easy_modal_banner_theme_data.dart';
export 'src/core/dismissibles/dismissibles.dart';
export 'src/core/dismissibles/types/easy_positioned_dismissible_type.dart';
export 'src/core/flutter_easy_dialogs/flutter_easy_dialogs_theme.dart';
export 'src/core/managers/custom_dialog_manager/strategy.dart'
    hide CustomEntriesAccessor;
export 'src/core/managers/managers.dart'
    show
        EasyDialogManagerBase,
        ManagerHideParamsBase,
        ManagerShowParamsBase,
        BlockAndroidBackButtonMixin,
        SingleAutoDisposalControllerMixin;
export 'src/core/overlay/easy_overlay.dart'
    show EasyOverlayInsertStrategy, EasyOverlayRemoveStrategy;

// Service - helper for easy use different custom dialogs
class FlutterEasyDialogs extends StatelessWidget {
  final CustomManagerBuilder? customManagerBuilder;

  /// Child widget
  final Widget child;

  /// Creates an instance of [FlutterEasyDialogs]
  const FlutterEasyDialogs({
    required this.child,
    this.customManagerBuilder,
    super.key,
  });

  static final _key = GlobalKey<EasyOverlayState>();

  /// Gets [EasyDialogsController]
  static EasyDialogsController get dialogsController =>
      _key.currentState!.easyDialogsController;

  /// For using in [MaterialApp.builder]
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
        key: _key,
        customManagersBuilder: customManagerBuilder,
        initialEntries: [
          EasyOverlayAppEntry(
            builder: (context) => child,
          ),
        ],
      ),
    );
  }
}
