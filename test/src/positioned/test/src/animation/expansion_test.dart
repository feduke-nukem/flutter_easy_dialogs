import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:positioned_dialog_manager/positioned_dialog_manager.dart';

import '../../helper.dart';

void main() {
  test('decorate', () {
    expect(
      () => const PositionedAnimator.expansion(curve: testCurve).call(
        PositionedAnimation(
          position: EasyDialogPosition.center,
          parent: createTestController(),
          dialog: Container(),
        ),
      ),
      returnsNormally,
    );
  });

  testGoldens('multi screen top', (widgetTester) async {
    final widget =
        const PositionedAnimator.expansion(curve: Curves.bounceIn).call(
      PositionedAnimation(
        position: EasyDialogPosition.top,
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
        home: Scaffold(body: child),
      ),
    );

    await multiScreenGolden(widgetTester, 'multi_screen_top');
  });
}
