import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('inserting', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(app);
      expect(
        easyOverlayState.currentEntries[EasyOverlayEntriesAccessKeys.custom],
        isNull,
      );

      late final int id;

      easyOverlayState.insertDialog(
        EasyOverlayInsertStrategy.custom(
          dialog: const SizedBox.shrink(key: dialogKey),
          onInserted: (dialogId) => id = dialogId,
        ),
      );

      expect(id, 0);

      expect(
        easyOverlayState.currentEntries[EasyOverlayEntriesAccessKeys.custom],
        isNotNull,
      );

      expect(
        EasyOverlayEntriesRawAccessor.custom(easyOverlayState).length,
        1,
      );

      await widgetTester.pump();

      expect(find.byKey(dialogKey), findsOneWidget);
    });
  });

  testWidgets('insert ten', (widgetTester) async {
    await widgetTester.pumpWidget(app);

    for (var i = 0; i < 10; i++) {
      easyOverlayState.insertDialog(
        EasyOverlayInsertStrategy.custom(
          dialog: const SizedBox.shrink(),
        ),
      );
    }

    expect(EasyOverlayEntriesRawAccessor.custom(easyOverlayState).length, 10);

    await widgetTester.pump();
    expect(find.byType(SizedBox), findsNWidgets(10));
  });

  group('removing', () {
    testWidgets('remove without adding', (widgetTester) async {
      await widgetTester.pumpWidget(app);

      expect(
        () => easyOverlayState
            .removeDialog(EasyOverlayRemoveStrategy.custom(dialogId: 0)),
        throwsAssertionError,
      );
    });

    testWidgets('insert and remove', (widgetTester) async {
      await widgetTester.pumpWidget(app);

      late final int id;
      easyOverlayState
        ..insertDialog(
          EasyOverlayInsertStrategy.custom(
            dialog: const SizedBox.shrink(
              key: dialogKey,
            ),
            onInserted: (dialogId) => id = dialogId,
          ),
        )
        ..removeDialog(EasyOverlayRemoveStrategy.custom(dialogId: id));

      expect(EasyOverlayEntriesRawAccessor.custom(easyOverlayState), isNotNull);

      expect(
        EasyOverlayEntriesRawAccessor.custom(easyOverlayState).length,
        isZero,
      );

      await widgetTester.pump();
      expect(find.byKey(dialogKey), findsNothing);
    });
  });
}
