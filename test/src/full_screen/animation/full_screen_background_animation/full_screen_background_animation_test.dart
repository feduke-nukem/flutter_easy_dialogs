import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helper.dart';

const _animations = [
  FullScreenBackgroundAnimation.blur(curve: testCurve),
  FullScreenBackgroundAnimation.fade(curve: testCurve),
];

void main() {
  group(
    'full screen background animation',
    () {
      test(
        'create all',
        () {
          _animations.forEach((element) {
            expect(
              () => element,
              returnsNormally,
            );
          });
        },
      );
      testWidgets(
        'show and hide',
        (widgetTester) async {
          for (final animation in _animations) {
            final dialog = EasyDialog.fullScreen(
              content: SizedBox(key: dialogKey),
              decoration: animation,
            );
            await showAndHide(
              widgetTester,
              dialog,
              FullScreenDialog.identifier(),
            );
          }
        },
      );
    },
  );
}
