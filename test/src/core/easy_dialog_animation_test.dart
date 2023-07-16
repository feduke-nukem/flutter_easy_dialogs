import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

final _animations = [
  EasyDialogAnimation.expansion(),
  EasyDialogAnimation.fade(),
  EasyDialogAnimation.blurBackground(),
  EasyDialogAnimation.fadeBackground(),
  EasyDialogAnimation.bounce(),
  EasyDialogAnimation.expansion().interval(0.0, 1.0),
  EasyDialogAnimation.expansion().reversed(),
  EasyDialogAnimation.expansion().tweenSequence(TweenSequence([
    TweenSequenceItem(
      tween: Tween(
        begin: 0.0,
        end: 0.9,
      ),
      weight: 0.3,
    )
  ])),
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
              content: SizedBox(key: dialogKey),
            ),
            PositionedDialog.identifier(position: EasyDialogPosition.top),
            pumpAndSettleDuration: const Duration(seconds: 3),
          );
        }
      },
    );
  });
}
