import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEasyOverlayController extends TestVSync implements IEasyOverlay {
  @override
  void insertDialog(EasyOverlayBoxInsert strategy) {}

  @override
  void removeDialog(EasyOverlayBoxRemove strategy) {}
}

class FakeAnimation<T> extends Animation<T> {
  @override
  final T value;

  @override
  AnimationStatus get status => AnimationStatus.completed;

  @override
  const FakeAnimation(this.value);

  @override
  void addListener(VoidCallback listener) {}

  @override
  void addStatusListener(AnimationStatusListener listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void removeStatusListener(AnimationStatusListener listener) {}
}
