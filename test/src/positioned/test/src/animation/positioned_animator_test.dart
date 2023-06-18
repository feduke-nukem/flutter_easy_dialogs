import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:positioned_dialog_manager/src/animation/positioned_animator.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';

import '../../helper.dart';

void main() {
  test('create all', () {
    expect(
      () => const PositionedAnimator.expansion(curve: testCurve),
      returnsNormally,
    );
    expect(
      () => const PositionedAnimator.fade(curve: testCurve),
      returnsNormally,
    );
    expect(
      () => const PositionedAnimator.verticalSlide(curve: testCurve),
      returnsNormally,
    );
  });

  test('create data', () {
    expect(
      () => PositionedAnimation(
        position: EasyDialogPosition.top,
        parent: createTestController(),
        dialog: Container(),
      ),
      returnsNormally,
    );

    const position = EasyDialogPosition.top;
    final parent = createTestController();
    final dialog = Container();

    final data = PositionedAnimation(
      position: position,
      parent: parent,
      dialog: dialog,
    );

    expect(data.position, position);
    expect(data.parent, parent);
    expect(data.dialog, dialog);
  });
}
