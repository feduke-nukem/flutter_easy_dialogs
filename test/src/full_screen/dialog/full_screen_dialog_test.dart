import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

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
  group('full screen dialog', () {
    testWidgets('show and hide', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      easyOverlayState.controller.show(
        EasyDialog.fullScreen(content: _content),
      );

      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsOneWidget);

      expect(easyOverlayState.box.currentEntries.isNotEmpty, isTrue);
      expect(easyOverlayState.box.get(FullScreenDialog),
          isA<EasyDialogsOverlayEntry>());

      easyOverlayState.controller.hide(FullScreenDialog.identifier());

      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsNothing);

      expect(easyOverlayState.box.currentEntries.isEmpty, isTrue);
      expect(easyOverlayState.box.get(FullScreenDialog), isNull);
    });

    testWidgets('show one, then show another', (widgetTester) async {
      await widgetTester.pumpWidget(
        app(),
      );

      easyOverlayState.controller.show(
        EasyDialog.fullScreen(content: _content),
      );

      await widgetTester.pumpAndSettle();

      easyOverlayState.controller.show(
        EasyDialog.fullScreen(
          content: Container(
            key: const Key('value'),
          ),
        ),
      );

      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsNothing);
      expect(find.byKey(const Key('value')), findsOneWidget);

      expect(easyOverlayState.box.currentEntries.isNotEmpty, isTrue);
      expect(easyOverlayState.box.get(FullScreenDialog), isNotNull);
    });
  });
}
