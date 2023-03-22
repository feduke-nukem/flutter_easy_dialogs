import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';

const _defaultDuration = Duration(microseconds: 350);
const _defaultReverseDuration = Duration(milliseconds: 350);

/// Configuration of [EasyDialogAnimator].

/// This is typically used to configure the [AnimationController]
/// that is created by [EasyDialogManager] and provide its
/// [AnimationController.view] to the [EasyDialogAnimator.animate] method,
/// which implies the application of any kind of animations driven
/// by this [AnimationController].
///
/// * Actually, all of these properties effectively map to the
/// constructor of [AnimationController].
class EasyDialogAnimatorConfiguration {
  /// Duration.
  final Duration duration;

  /// Reverse duration.
  final Duration reverseDuration;

  /// Value from which animation should start.
  final double startValue;

  /// The value at which this animation is deemed to be dismissed.
  final double lowerBound;

  /// The value at which this animation is deemed to be completed.
  final double upperBound;

  /// Creates an instance of [EasyDialogAnimatorConfiguration].
  const EasyDialogAnimatorConfiguration({
    double? startValue,
    this.duration = _defaultDuration,
    this.reverseDuration = _defaultReverseDuration,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
  })  : this.startValue = startValue ?? lowerBound,
        assert(upperBound >= lowerBound);

  /// Unbounded.
  const EasyDialogAnimatorConfiguration.unbounded({
    double startValue = 0.0,
    this.duration = _defaultDuration,
    this.reverseDuration = _defaultReverseDuration,
  })  : lowerBound = double.negativeInfinity,
        upperBound = double.infinity,
        this.startValue = startValue;

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyDialogAnimatorConfiguration &&
        duration == other.duration &&
        reverseDuration == other.duration &&
        startValue == other.startValue &&
        lowerBound == other.lowerBound &&
        upperBound == other.upperBound;
  }

  @override
  int get hashCode {
    final values = [
      reverseDuration,
      duration,
      startValue,
      lowerBound,
      upperBound,
    ];

    return Object.hashAll(values);
  }
}
