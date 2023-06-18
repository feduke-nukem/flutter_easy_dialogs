import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  test('create params', () {
    expect(
      () => EasyDialog(child: Container()),
      returnsNormally,
    );
    expect(() => EasyDialogManagerHideParams(), returnsNormally);
  });
  group('strategy insert', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(app());
      expect(
        easyOverlayState.box.currentEntries[EasyDialogsController],
        isNull,
      );

      late final int id;

      easyOverlayState.insertDialog(
        BasicDialogInsert(
          dialog: const SizedBox.shrink(key: dialogKey),
          onInserted: (dialogId) => id = dialogId,
        ),
      );

      expect(id, 0);

      expect(
        easyOverlayState.box.currentEntries[EasyDialogsController],
        isNotNull,
      );

      expect(
        easyOverlayState.box
            .get<List<EasyOverlayEntry>>(EasyDialogsController)!
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
        BasicDialogInsert(
          dialog: Container(),
        ),
      );
    }

    expect(
        easyOverlayState.box
            .get<List<EasyOverlayEntry>>(EasyDialogsController)!
            .length,
        10);

    await widgetTester.pump();
    expect(find.byType(Container), findsNWidgets(10));
  });

  group('strategy removing', () {
    testWidgets('remove without adding', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      expect(
        () =>
            easyOverlayState.removeDialog(const BasicDialogRemove(dialogId: 0)),
        throwsAssertionError,
      );
    });

    testWidgets('insert and remove', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      late final int id;
      easyOverlayState
        ..insertDialog(
          BasicDialogInsert(
            dialog: const SizedBox.shrink(
              key: dialogKey,
            ),
            onInserted: (dialogId) => id = dialogId,
          ),
        )
        ..removeDialog(BasicDialogRemove(dialogId: id));

      expect(
          easyOverlayState.box
              .get<List<EasyOverlayEntry>>(EasyDialogsController),
          isNotNull);

      expect(
        easyOverlayState.box
            .get<List<EasyOverlayEntry>>(EasyDialogsController)!
            .length,
        isZero,
      );

      await widgetTester.pump();
      expect(find.byKey(dialogKey), findsNothing);
    });
  });
}
