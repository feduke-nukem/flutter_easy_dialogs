import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/src/dismissible/full_screen_dismissible.dart';
import 'package:full_screen_dialog_manager/src/manager/full_screen_show_params.dart';
import 'package:full_screen_dialog_manager/src/util/full_screen_dialog_controller_x.dart';
import 'package:full_screen_dialog_manager/src/util/full_screen_manager_registrar_x.dart';

import '../../helper.dart';

void main() {
  testWidgets('show and tap with gesture dismissible', (widgetTester) async {
    await widgetTester.pumpWidget(app(
      setupManagers: (overlayController, managerRegistrar) {
        managerRegistrar.registerFullScreen(overlayController);
      },
    ));

    easyOverlayState.dialogManagerProvider.showFullScreen(
      const FullScreenShowParams(
        content: SizedBox(
          key: dialogKey,
          height: 300.0,
          width: 300.0,
        ),
        dismissible: FullScreenDismissible.tap(),
      ),
    );

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);

    final finder = find.byKey(dialogKey);

    await widgetTester.tap(finder);

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);
  });
}
