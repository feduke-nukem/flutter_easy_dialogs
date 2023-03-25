import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_easy_dialogs/src/custom/manager/custom_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/custom/manager/strategy.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('inserting', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(app());
      expect(
        easyOverlayState.box.currentEntries[CustomDialogManager],
        isNull,
      );

      late final int id;

      easyOverlayState.insertDialog(
        CustomDialogInsertStrategy(
          dialog: const SizedBox.shrink(key: dialogKey),
          onInserted: (dialogId) => id = dialogId,
        ),
      );

      expect(id, 0);

      expect(
        easyOverlayState.box.currentEntries[CustomDialogManager],
        isNotNull,
      );

      expect(
        easyOverlayState.box
            .get<List<EasyOverlayEntry>>(CustomDialogManager)!
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
        CustomDialogInsertStrategy(
          dialog: Container(),
        ),
      );
    }

    expect(
        easyOverlayState.box
            .get<List<EasyOverlayEntry>>(CustomDialogManager)!
            .length,
        10);

    await widgetTester.pump();
    expect(find.byType(Container), findsNWidgets(10));
  });

  group('removing', () {
    testWidgets('remove without adding', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      expect(
        () => easyOverlayState
            .removeDialog(const CustomDialogRemoveStrategy(dialogId: 0)),
        throwsAssertionError,
      );
    });

    testWidgets('insert and remove', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      late final int id;
      easyOverlayState
        ..insertDialog(
          CustomDialogInsertStrategy(
            dialog: const SizedBox.shrink(
              key: dialogKey,
            ),
            onInserted: (dialogId) => id = dialogId,
          ),
        )
        ..removeDialog(CustomDialogRemoveStrategy(dialogId: id));

      expect(
          easyOverlayState.box.get<List<EasyOverlayEntry>>(CustomDialogManager),
          isNotNull);

      expect(
        easyOverlayState.box
            .get<List<EasyOverlayEntry>>(CustomDialogManager)!
            .length,
        isZero,
      );

      await widgetTester.pump();
      expect(find.byKey(dialogKey), findsNothing);
    });
  });
}
