import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  testWidgets('show and hide all positions', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: FlutterEasyDialogs.builder(),
      ),
    );

    for (final position in EasyDialogPosition.values) {
      FlutterEasyDialogs.show(
        EasyDialog.positioned(
          id: position,
          decoration: PositionedShell.banner()
              .chained(EasyDialogAnimation.fade())
              .chained(EasyDialogDismiss.tap())
              .chained(
                EasyDialogAnimation.slideVertical(),
              ),
          content: Container(
            key: dialogKey,
          ),
          position: position,
          autoHideDuration: null,
        ),
      );
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byKey(dialogKey), findsOneWidget);
      FlutterEasyDialogs.hide(id: position);
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byKey(dialogKey), findsNothing);
    }
  });
}
