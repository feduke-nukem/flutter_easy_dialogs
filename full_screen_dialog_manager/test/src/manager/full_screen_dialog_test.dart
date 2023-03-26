import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/src/manager/full_screen_dialog_manager.dart';
import 'package:full_screen_dialog_manager/src/util/full_screen_dialog_controller_x.dart';
import 'package:full_screen_dialog_manager/src/util/full_screen_manager_registrar_x.dart';

import '../../helper.dart';

final _content = Container(
  key: dialogKey,
  height: 200,
  width: 200,
  color: Colors.blue,
  alignment: Alignment.center,
  child: const Text(
    'Full screen dialog',
    textAlign: TextAlign.center,
  ),
);

void main() {
  testWidgets('show and hide', (widgetTester) async {
    await widgetTester.pumpWidget(app(
      setupManagers: (overlayController, managerRegistrar) {
        managerRegistrar.registerFullScreen(overlayController);
      },
    ));

    easyOverlayState.dialogManagerController
        .showFullScreen(FullScreenShowParams(content: _content));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);

    expect(easyOverlayState.box.currentEntries.isNotEmpty, isTrue);
    expect(easyOverlayState.box.get(FullScreenDialogManager),
        isA<EasyDialogsOverlayEntry>());

    easyOverlayState.dialogManagerController.hideFullScreen();

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);

    expect(easyOverlayState.box.currentEntries.isEmpty, isTrue);
    expect(easyOverlayState.box.get(FullScreenDialogManager), isNull);
  });

  testWidgets('show one, then show another', (widgetTester) async {
    await widgetTester.pumpWidget(app(
      setupManagers: (overlayController, managerRegistrar) {
        managerRegistrar.registerFullScreen(overlayController);
      },
    ));

    easyOverlayState.dialogManagerController
        .showFullScreen(FullScreenShowParams(content: _content));

    await widgetTester.pumpAndSettle();

    easyOverlayState.dialogManagerController.showFullScreen(
      FullScreenShowParams(
        content: Container(
          key: const Key('value'),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);
    expect(find.byKey(const Key('value')), findsOneWidget);

    expect(easyOverlayState.box.currentEntries.isNotEmpty, isTrue);
    expect(easyOverlayState.box.get(FullScreenDialogManager), isNotNull);
  });
}
