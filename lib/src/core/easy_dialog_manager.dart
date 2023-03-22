import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator_configuration.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart'
    show IEasyOverlayController;
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay.dart';

/// Base class for all dialog managers.
///
/// It is responsible for managing specific to its scope dialogs:
/// * Inserting/removing and showing/hiding
/// created dialog into [EasyDialogsOverlay]
/// * Applying provided configurations
abstract class EasyDialogManager<S extends EasyDialogManagerShowParams?,
    H extends EasyDialogManagerHideParams?> {
  /// [IEasyOverlayController] is used for providing [Ticker]
  /// for creating animations and inserting dialogs into [Overlay].
  @protected
  @nonVirtual
  final IEasyOverlayController overlayController;

  /// Creates an instance of [EasyDialogManager].
  const EasyDialogManager({
    required this.overlayController,
  });

  /// An abstract show method of dialog agent with covariant [params].
  ///
  /// This is the core method for displaying dialogs.
  Future<void> show({
    required S params,
  });

  /// An abstract hide method of dialog agent with covariant [params].
  ///
  /// This is the core method for removing dialogs from the screen.
  Future<void> hide({
    required H params,
  });
}

/// Base data class of show params for dialog managers.
abstract class EasyDialogManagerShowParams {
  /// Content for showing.
  final Widget content;

  /// Animation settings.
  final EasyDialogAnimatorConfiguration animationConfiguration;

  /// Creates an instance of [EasyDialogManagerShowParams].
  const EasyDialogManagerShowParams({
    required this.content,
    this.animationConfiguration = const EasyDialogAnimatorConfiguration(),
  });
}

/// Base data class of hide params for dialog managers.
abstract class EasyDialogManagerHideParams {
  /// Creates an instance of [EasyDialogManagerHideParams].
  const EasyDialogManagerHideParams();
}
