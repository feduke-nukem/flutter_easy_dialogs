const _defaultDuration = Duration(microseconds: 350);
const _defaultReverseDuration = Duration(milliseconds: 350);

/// Data class of animation play information.
class EasyAnimationConfiguration {
  /// Animation's duration.
  final Duration duration;

  /// Animation's reverse duration.
  final Duration reverseDuration;

  /// Value from which animation should start.
  final double startValue;

  /// The value at which this animation is deemed to be dismissed.
  final double lowerBound;

  /// The value at which this animation is deemed to be completed.
  final double upperBound;

  /// @nodoc.
  final bool isUnbound;

  /// Creates an instance of [EasyAnimationConfiguration].
  const EasyAnimationConfiguration({
    double? startValue,
    this.duration = _defaultDuration,
    this.reverseDuration = _defaultReverseDuration,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
  })  : this.startValue = startValue ?? lowerBound,
        isUnbound = false,
        assert(upperBound >= lowerBound);

  /// Unbound.
  const EasyAnimationConfiguration.unbound({
    double startValue = 0.0,
    this.duration = _defaultDuration,
    this.reverseDuration = _defaultReverseDuration,
  })  : lowerBound = double.negativeInfinity,
        upperBound = double.infinity,
        isUnbound = true,
        this.startValue = startValue;

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyAnimationConfiguration &&
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

  EasyAnimationConfiguration copyWith({
    Duration? duration,
    Duration? reverseDuration,
    double? startValue,
    double? lowerBound,
    double? upperBound,
  }) =>
      EasyAnimationConfiguration(
        startValue: startValue ?? this.startValue,
        duration: duration ?? this.duration,
        reverseDuration: reverseDuration ?? this.reverseDuration,
        lowerBound: lowerBound ?? this.lowerBound,
        upperBound: upperBound ?? this.upperBound,
      );
}
