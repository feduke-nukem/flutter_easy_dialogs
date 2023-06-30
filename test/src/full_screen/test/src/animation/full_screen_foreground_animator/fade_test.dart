import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';

import '../../../helper.dart';

void main() {
  test('decorate', () {
    const blur = FullScreenForegroundAnimation.fade(curve: testCurve);
    final data = EasyDialogAnimation(
      parent: createTestController(),
      dialog: Container(),
    );

    expect(() => blur.call(data), returnsNormally);
  });
}
