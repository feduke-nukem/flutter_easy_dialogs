import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  group('strategy insert', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(app());
      expect(
        easyOverlayState.box.currentEntries[EasyDialogManager],
        isNull,
      );

      late final int id;

      easyOverlayState.insertDialog(
        BasicDialogInsertStrategy(
          dialog: const SizedBox.shrink(key: dialogKey),
          onInserted: (dialogId) => id = dialogId,
        ),
      );

      expect(id, 0);

      expect(
        easyOverlayState.box.currentEntries[EasyDialogManager],
        isNotNull,
      );

      expect(
        easyOverlayState.box
            .get<List<EasyOverlayEntry>>(EasyDialogManager)!
            .length,
        1,
      );

      await widgetTester.pump();

      expect(find.byKey(dialogKey), findsOneWidget);
    });
  });

  testWidgets('insert ten', (widgetTester) async {
    await widgetTester.pumpWidget(app());

    for (var i = 0; i < 10; i++) {
      easyOverlayState.insertDialog(
        BasicDialogInsertStrategy(
          dialog: Container(),
        ),
      );
    }

    expect(
        easyOverlayState.box
            .get<List<EasyOverlayEntry>>(EasyDialogManager)!
            .length,
        10);

    await widgetTester.pump();
    expect(find.byType(Container), findsNWidgets(10));
  });

  group('strategy removing', () {
    testWidgets('remove without adding', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      expect(
        () => easyOverlayState
            .removeDialog(const BasicDialogRemoveStrategy(dialogId: 0)),
        throwsAssertionError,
      );
    });

    testWidgets('insert and remove', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      late final int id;
      easyOverlayState
        ..insertDialog(
          BasicDialogInsertStrategy(
            dialog: const SizedBox.shrink(
              key: dialogKey,
            ),
            onInserted: (dialogId) => id = dialogId,
          ),
        )
        ..removeDialog(BasicDialogRemoveStrategy(dialogId: id));

      expect(
          easyOverlayState.box.get<List<EasyOverlayEntry>>(EasyDialogManager),
          isNotNull);

      expect(
        easyOverlayState.box
            .get<List<EasyOverlayEntry>>(EasyDialogManager)!
            .length,
        isZero,
      );

      await widgetTester.pump();
      expect(find.byKey(dialogKey), findsNothing);
    });
  });
}
