import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';

const _defaultDuration = Duration(milliseconds: 350);
const _defaultReverseDuration = Duration(milliseconds: 350);

/// {@category Dialogs}
/// {@template easy_dialog_animation_configuration}
/// Configuration of [EasyDialogAnimation].
///
/// This is typically used to configure the [Animation]
/// that is created by [EasyDialogsController] which implies to drive any
/// kind of animations that can be applied to the dialog.
/// {@endtemplate}
sealed class EasyDialogAnimationConfiguration {
  /// @nodoc
  const EasyDialogAnimationConfiguration();

  /// See [AnimationController].
  const factory EasyDialogAnimationConfiguration.bounded({
    double? startValue,
    Duration duration,
    Duration reverseDuration,
    double lowerBound,
    double upperBound,
  }) = AnimationConfigurationBounded;

  /// See [AnimationController.unbounded].
  const factory EasyDialogAnimationConfiguration.unbounded({
    double startValue,
    Duration duration,
    Duration reverseDuration,
  }) = AnimationConfigurationUnbounded;

  /// Create configuration using an [AnimationController].
  ///
  /// * The [willDispose] is whether the controller should be disposed by
  /// [EasyDialogsController] when the dialog is dismissed.
  ///
  /// * The [willForward] is whether the controller should be started by
  /// [EasyDialogsController] when the dialog is intended to be shown.
  ///
  /// * The [willReverse] is whether the controller should be reversed by
  /// [EasyDialogsController] when the dialog is intended to be dismissed.
  const factory EasyDialogAnimationConfiguration.withController(
    AnimationController controller, {
    bool willForward,
    bool willReverse,
    bool willDispose,
  }) = AnimationConfigurationWithController;
}

final class AnimationConfigurationWithController
    extends EasyDialogAnimationConfiguration {
  final AnimationController controller;
  final bool willForward;
  final bool willReverse;
  final bool willDispose;

  const AnimationConfigurationWithController(
    this.controller, {
    this.willForward = false,
    this.willReverse = false,
    this.willDispose = false,
  });
}

sealed class AnimationConfigurationWithoutController
    extends EasyDialogAnimationConfiguration {
  const AnimationConfigurationWithoutController();

  AnimationController createController(TickerProvider vsync);
}

final class AnimationConfigurationBounded
    extends AnimationConfigurationWithoutController {
  final Duration duration;
  final Duration reverseDuration;
  final double startValue;
  final double lowerBound;
  final double upperBound;

  const AnimationConfigurationBounded({
    double? startValue,
    this.duration = _defaultDuration,
    this.reverseDuration = _defaultReverseDuration,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
  })  : this.startValue = startValue ?? lowerBound,
        assert(upperBound >= lowerBound);

  @override
  AnimationController createController(TickerProvider vsync) =>
      AnimationController(
        value: startValue,
        duration: duration,
        reverseDuration: reverseDuration,
        lowerBound: lowerBound,
        upperBound: upperBound,
        vsync: vsync,
      );
}

final class AnimationConfigurationUnbounded
    extends AnimationConfigurationWithoutController {
  final Duration duration;
  final Duration reverseDuration;
  final double startValue;

  const AnimationConfigurationUnbounded({
    this.startValue = 0.0,
    this.duration = _defaultDuration,
    this.reverseDuration = _defaultReverseDuration,
  });

  @override
  AnimationController createController(TickerProvider vsync) =>
      AnimationController.unbounded(
        value: startValue,
        duration: duration,
        reverseDuration: reverseDuration,
        vsync: vsync,
      );
}
