import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/src/animation/full_screen_background_animator/full_screen_background_animator.dart';

import '../../../helper.dart';

void main() {
  test('decorate', () {
    const blur = FullScreenBackgroundAnimator.fade(curve: testCurve);
    final data = EasyDialogAnimatorData(
      parent: createTestController(),
      dialog: Container(),
    );

    expect(() => blur.decorate(data), returnsNormally);
  });
}
