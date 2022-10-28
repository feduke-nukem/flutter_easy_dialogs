import 'package:flutter/widgets.dart';

class MultiplyAnimation extends CompoundAnimation<double> {
  MultiplyAnimation({
    required super.first,
    required super.next,
  });

  @override
  double get value => first.value * next.value;
}
