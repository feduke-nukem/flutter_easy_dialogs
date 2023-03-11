import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('inserting', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(app);

      expect(
        easyOverlayState
            .currentEntries[EasyOverlayEntriesAccessKeys.fullScreen],
        isNull,
      );

      easyOverlayState.insertDialog(
        EasyOverlayInsertStrategy.fullScreen(
          dialog: const SizedBox.shrink(
            key: dialogKey,
          ),
        ),
      );

      expect(
        easyOverlayState
            .currentEntries[EasyOverlayEntriesAccessKeys.fullScreen],
        isNotNull,
      );

      await widgetTester.pump();

      expect(find.byKey(dialogKey), findsOneWidget);
    });
  });

  testWidgets(
    'inserted twice',
    (widgetTester) async {
      await widgetTester.pumpWidget(app);

      easyOverlayState.insertDialog(
        EasyOverlayInsertStrategy.fullScreen(
          dialog: const SizedBox.shrink(
            key: dialogKey,
          ),
        ),
      );

      expect(
        () => easyOverlayState.insertDialog(
          EasyOverlayInsertStrategy.fullScreen(
            dialog: const SizedBox.shrink(
              key: dialogKey,
            ),
          ),
        ),
        throwsAssertionError,
      );

      await widgetTester.pump();

      expect(find.byKey(dialogKey), findsOneWidget);
    },
  );

  group('removing', () {
    testWidgets('insert and remove', (widgetTester) async {
      await widgetTester.pumpWidget(app);

      easyOverlayState
        ..insertDialog(
          EasyOverlayInsertStrategy.fullScreen(
            dialog: const SizedBox.shrink(
              key: dialogKey,
            ),
          ),
        )
        ..removeDialog(EasyOverlayRemoveStrategy.fullScreen());

      expect(
        easyOverlayState
            .currentEntries[EasyOverlayEntriesAccessKeys.fullScreen],
        isNull,
      );

      expect(find.byKey(dialogKey), findsNothing);
    });
  });
}
