import 'package:flutter/material.dart';

/// Data class of animation information
class EasyAnimationSettings {
  /// Animation's duration
  final Duration duration;

  /// Animation's reverse duration
  final Duration reverseDuration;

  /// Animation's curve
  final Curve curve;

  const EasyAnimationSettings({
    required this.curve,
    required this.duration,
    required this.reverseDuration,
  });

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyAnimationSettings &&
        duration == other.duration &&
        reverseDuration == other.duration &&
        curve == other.curve;
  }

  @override
  int get hashCode {
    final values = [
      curve,
      reverseDuration,
      duration,
    ];

    return Object.hashAll(values);
  }
}
