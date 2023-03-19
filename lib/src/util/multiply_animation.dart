import 'package:flutter/widgets.dart';

/// [CompoundAnimation] for multiplying two passed animations.
class MultiplyAnimation extends CompoundAnimation<double> {
  /// Creates an instance of MultiplyAnimation.
  MultiplyAnimation({
    required super.first,
    required super.next,
  });

  @override
  double get value => first.value * next.value;
}
