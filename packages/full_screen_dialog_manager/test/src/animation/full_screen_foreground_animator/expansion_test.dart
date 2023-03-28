import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';

import '../../../helper.dart';

void main() {
  test('decorate', () {
    const blur = FullScreenForegroundAnimator.expansion(curve: testCurve);
    final data = EasyDialogAnimatorData(
      parent: createTestController(),
      dialog: Container(),
    );

    expect(() => blur.decorate(data), returnsNormally);
  });

  testWidgets('show and hide', (widgetTester) async {
    const content = SizedBox(key: dialogKey);

    await widgetTester.pumpWidget(app(
      setupManagers: (overlayController, managerRegistrar) {
        managerRegistrar.registerFullScreen(overlayController);
      },
    ));

    easyOverlayState.dialogManagerProvider.showFullScreen(
      const FullScreenShowParams(
        content: content,
        foregroundAnimator: FullScreenForegroundAnimator.expansion(),
      ),
    );

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);

    easyOverlayState.dialogManagerProvider.hideFullScreen();

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);
  });
}
