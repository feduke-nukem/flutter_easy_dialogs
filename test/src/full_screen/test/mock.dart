import 'package:flutter/material.dart';

class MockAnimation<T> extends Animation<T> {
  @override
  final T value;

  @override
  AnimationStatus get status => AnimationStatus.completed;

  @override
  const MockAnimation(this.value);

  @override
  void addListener(VoidCallback listener) {}

  @override
  void addStatusListener(AnimationStatusListener listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void removeStatusListener(AnimationStatusListener listener) {}
}
