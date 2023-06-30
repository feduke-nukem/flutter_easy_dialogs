import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animation.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';

const _defaultDuration = Duration(milliseconds: 350);
const _defaultReverseDuration = Duration(milliseconds: 350);

/// {@category Dialog manager}
/// Configuration of [EasyDialogAnimation].
///
/// This is typically used to configure the [AnimationController]
/// that is created by [EasyDialogsController] and provided to the
/// [EasyDialogAnimation.call] method as [AnimationController.view],
/// which implies to drive any kind of animations that can be applied to the
/// dialog.
///
/// * Actually, all of these properties perfectly map to the
/// constructor of [AnimationController].
final class EasyDialogAnimationConfiguration {
  /// The duration of the animation.
  final Duration duration;

  /// The duration of the animation in reverse.
  final Duration reverseDuration;

  /// The value from which the animation should start.
  final double startValue;

  /// The value at which this animation is deemed to be dismissed.
  final double lowerBound;

  /// The value at which this animation is deemed to be completed.
  final double upperBound;

  /// Creates an instance of [EasyDialogAnimationConfiguration].
  const EasyDialogAnimationConfiguration({
    double? startValue,
    this.duration = _defaultDuration,
    this.reverseDuration = _defaultReverseDuration,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
  })  : this.startValue = startValue ?? lowerBound,
        assert(upperBound >= lowerBound);

  /// Creates an instance of [EasyDialogAnimationConfiguration]
  /// for an unbounded animation.
  ///
  /// An unbounded animation is one that does not have a fixed [lowerBound]
  /// or [upperBound].
  ///
  /// The [duration] is the duration of the animation,
  /// and defaults to [_defaultDuration].
  ///
  /// The [reverseDuration] is the duration of the animation in reverse,
  /// and defaults to the [_defaultReverseDuration].
  ///
  /// The [startValue] is the value from which the animation should start,
  /// and defaults to `0.0`.
  const EasyDialogAnimationConfiguration.unbounded({
    double startValue = 0.0,
    this.duration = _defaultDuration,
    this.reverseDuration = _defaultReverseDuration,
  })  : lowerBound = double.negativeInfinity,
        upperBound = double.infinity,
        this.startValue = startValue;

  /// Creates an [AnimationController] based on provided values.
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
