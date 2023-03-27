import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:positioned_dialog_manager/src/animation/positioned_animator.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';

import '../../helper.dart';

void main() {
  test('decorate', () {
    expect(
      () => const PositionedAnimator.fade(curve: testCurve).decorate(
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
