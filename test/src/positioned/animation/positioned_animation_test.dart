import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

const _animations = [
  PositionedAnimation.verticalSlide(),
];

void main() {
  group('positioned animations', () {
    test('create all', () {
      _animations.forEach((animation) {
        expect(() => animation, returnsNormally);
      });
    });

    testWidgets(
      'show and hide',
      (widgetTester) async {
        for (var element in _animations) {
          await showAndHide(
            widgetTester,
            EasyDialog.positioned(
              decoration: element,
              content: SizedBox(
                key: dialogKey,
              ),
            ),
            PositionedDialog.identifier(position: EasyDialogPosition.top),
            pumpAndSettleDuration: const Duration(seconds: 3),
          );
        }
      },
    );
  });
}
