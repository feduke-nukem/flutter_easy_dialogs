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
  EasyDialogAnimation.slideHorizontal(),
  EasyDialogAnimation.slideVertical(),
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

final _combined = EasyDialogDecoration.combine(_animations);

void main() {
  final animations = [_combined, ..._animations];
  group('positioned animations', () {
    test('create all', () {
      animations.forEach((animation) {
        expect(() => animation, returnsNormally);
      });
    });

    testWidgets(
      'show and hide positioned',
      (widgetTester) async {
        for (var element in animations) {
          await showAndHide(
            widgetTester,
            EasyDialog.positioned(
              autoHideDuration: null,
              decoration: element,
              content: SizedBox(key: dialogKey),
            ),
            PositionedDialog.identifier(position: EasyDialogPosition.top),
            pumpAndSettleDuration: const Duration(seconds: 3),
          );
        }
      },
    );

    testWidgets(
      'show and hide full screen',
      (widgetTester) async {
        for (var element in animations) {
          await showAndHide(
            widgetTester,
            EasyDialog.fullScreen(
              decoration: element,
              content: SizedBox(key: dialogKey),
            ),
            FullScreenDialog.identifier(),
            pumpAndSettleDuration: const Duration(seconds: 3),
          );
        }
      },
    );
  });
}
