import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  testWidgets('show and tap with gesture dismissible', (widgetTester) async {
    await widgetTester.pumpWidget(
      app(),
    );

    easyOverlayState.controller.show(
      EasyDialog.fullScreen(
        content: Container(
          color: Colors.red,
          key: dialogKey,
          height: 300.0,
          width: 300.0,
        ),
        decoration: FullScreenDismiss.tap(),
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
