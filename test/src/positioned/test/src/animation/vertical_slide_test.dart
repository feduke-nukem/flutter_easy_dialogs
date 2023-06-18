import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:meta/meta.dart';
import 'package:positioned_dialog_manager/src/animation/positioned_animator.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';

import '../../helper.dart';

void main() {
  test('decorate', () {
    expect(
      () => const PositionedAnimator.fade(curve: testCurve).call(
        PositionedAnimation(
          position: EasyDialogPosition.center,
          parent: createTestController(),
          dialog: Container(),
        ),
      ),
      returnsNormally,
    );
  });

  _testGoldedPosition(EasyDialogPosition.top);
  _testGoldedPosition(EasyDialogPosition.center);

  _testGoldedPosition(EasyDialogPosition.bottom);
}

@isTest
void _testGoldedPosition(EasyDialogPosition position) {
  testGoldens('multi screen $position', (widgetTester) async {
    final widget =
        const PositionedAnimator.verticalSlide(curve: Curves.bounceIn).call(
      PositionedAnimation(
        position: position,
        parent: createTestController()..forward(),
        dialog: Container(
          height: 100.0,
          width: double.infinity,
          color: Colors.pink,
        ),
      ),
    );

    await widgetTester.pumpWidgetBuilder(
      widget,
      wrapper: (child) => MaterialApp(
        home:
            Scaffold(body: Align(alignment: position.alignment, child: child)),
      ),
    );

    await multiScreenGolden(widgetTester, 'multi_screen_$position');
  });
}
