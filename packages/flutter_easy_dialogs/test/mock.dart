import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEasyOverlayController extends TestVSync
    implements IEasyOverlayController {
  @override
  void insertDialog(
      EasyOverlayBoxInsert<
              EasyDialogManager<EasyDialogManagerShowParams?,
                  EasyDialogManagerHideParams?>>
          strategy) {}

  @override
  void removeDialog(
      EasyOverlayBoxRemove<
              EasyDialogManager<EasyDialogManagerShowParams?,
                  EasyDialogManagerHideParams?>>
          strategy) {}
}

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
