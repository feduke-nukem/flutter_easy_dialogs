import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock.dart';

void main() {
  test('create', () {
    expect(
      () => EasyFullScreenBlurTransition(
        blur: const MockAnimation(0),
        child: Container(),
      ),
      returnsNormally,
    );
  });

  testGoldens('multi screen golden', (widgetTester) async {
    final widget = Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Text('test' * 10000)),
          Positioned.fill(
            child: EasyFullScreenBlurTransition(
              blur: const MockAnimation(10),
              backgroundColor: Colors.transparent,
              child: Center(
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  color: Colors.pink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    await widgetTester.pumpAndSettle();
    await widgetTester.pumpWidgetBuilder(
      widget,
      wrapper: (child) => MaterialApp(
        home: widget,
      ),
    );

    await multiScreenGolden(widgetTester, 'multi_screen');
  });
}
