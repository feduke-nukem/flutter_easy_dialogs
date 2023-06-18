import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/src/animation/full_screen_background_animator/full_screen_background_animator.dart';
import 'package:full_screen_dialog_manager/src/manager/full_screen_dialog.dart';
import 'package:full_screen_dialog_manager/src/util/full_screen_dialog_controller_x.dart';
import 'package:full_screen_dialog_manager/src/util/full_screen_manager_registrar_x.dart';

import '../../../helper.dart';

void main() {
  test('decorate', () {
    const blur = FullScreenBackgroundAnimator.fade(curve: testCurve);
    final data = EasyDialogAnimation(
      parent: createTestController(),
      dialog: Container(),
    );

    expect(() => blur.call(data), returnsNormally);
  });

  testWidgets('show and hide', (widgetTester) async {
    const content = SizedBox(key: dialogKey);

    await widgetTester.pumpWidget(app(
      setupManagers: (overlayController, managerRegistrar) {
        managerRegistrar.registerFullScreen(overlayController);
      },
    ));

    easyOverlayState.dialogManagerProvider.showFullScreen(
      const FullScreenDialog(
        content: content,
        backgroundAnimator: FullScreenBackgroundAnimator.fade(),
      ),
    );

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);

    easyOverlayState.dialogManagerProvider.hideFullScreen();

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);
  });
}
