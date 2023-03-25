import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator_configuration.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart'
    show IEasyOverlayController;
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay.dart';

/// This is the base class for all dialog managers.
///
/// The main idea is that any specific [EasyDialogManager]
/// is responsible for only two things: *`showing`* and *`hiding`* dialogs.
///
/// Therefore, there are two methods: [show] and [hide].
///
/// In other words, this class is responsible for managing dialogs that
/// are specific to it, including:
///
/// * Inserting and removing dialogs from [EasyDialogsOverlay].
/// * Applying any provided [EasyDialogDecorator] or multiple decorators.
abstract class EasyDialogManager<S extends EasyDialogManagerShowParams?,
    H extends EasyDialogManagerHideParams?> {
  /// [IEasyOverlayController] is used for providing [Ticker]
  /// for creating animations and inserting dialogs into [EasyDialogsOverlay].
  @protected
  @nonVirtual
  final IEasyOverlayController overlayController;

  /// Creates an instance of [EasyDialogManager].
  const EasyDialogManager({required this.overlayController});

  /// This is an abstract [show] method with a [params] of type [S].
  ///
  /// This is the core method used for displaying dialogs.
  Future<void> show({required S params});

  /// This is an abstract [hide] method with a [params] of type [H].
  ///
  /// This is the core method used for hiding dialogs.
  Future<void> hide({required H params});
}

/// Base data class of show params for dialog managers.
abstract class EasyDialogManagerShowParams {
  /// Content for showing.
  final Widget content;

  /// Animator settings.
  final EasyDialogAnimatorConfiguration animationConfiguration;

  /// Creates an instance of [EasyDialogManagerShowParams].
  const EasyDialogManagerShowParams({
    required this.content,
    this.animationConfiguration = const EasyDialogAnimatorConfiguration(),
  });
}

/// Base class of hide params for dialog managers.
abstract class EasyDialogManagerHideParams {
  /// Creates an instance of [EasyDialogManagerHideParams].
  const EasyDialogManagerHideParams();
}
