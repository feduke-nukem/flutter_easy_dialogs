import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:positioned_dialog_manager/positioned_dialog_manager.dart';

import '../../helper.dart';

void main() {
  test('decorate', () {
    expect(
      () => const PositionedAnimator.expansion(curve: testCurve).decorate(
        PositionedAnimatorData(
          position: EasyDialogPosition.center,
          parent: createTestController(),
          dialog: Container(),
        ),
      ),
      returnsNormally,
    );
  });
}
