import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/managers/full_screen_dialog_manager/full_screen_dialog_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('inserting', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      expect(
        easyOverlayState.currentEntries[FullScreenDialogEntriesAccessor.key],
        isNull,
      );

      easyOverlayState.insertDialog(
        const FullScreenDialogInsertStrategy(
          dialog: SizedBox.shrink(
            key: dialogKey,
          ),
        ),
      );

      expect(
        easyOverlayState.currentEntries[FullScreenDialogEntriesAccessor.key],
        isNotNull,
      );

      await widgetTester.pump();

      expect(find.byKey(dialogKey), findsOneWidget);
    });
  });

  testWidgets(
    'inserted twice',
    (widgetTester) async {
      await widgetTester.pumpWidget(app());

      easyOverlayState.insertDialog(
        const FullScreenDialogInsertStrategy(
          dialog: SizedBox.shrink(
            key: dialogKey,
          ),
        ),
      );

      expect(
        () => easyOverlayState.insertDialog(
          const FullScreenDialogInsertStrategy(
            dialog: SizedBox.shrink(
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
      await widgetTester.pumpWidget(app());

      easyOverlayState
        ..insertDialog(
          const FullScreenDialogInsertStrategy(
            dialog: SizedBox.shrink(
              key: dialogKey,
            ),
          ),
        )
        ..removeDialog(const FullScreenDialogRemoveStrategy());

      expect(
        easyOverlayState.currentEntries[FullScreenDialogEntriesAccessor.key],
        isNull,
      );

      expect(find.byKey(dialogKey), findsNothing);
    });
  });
}
