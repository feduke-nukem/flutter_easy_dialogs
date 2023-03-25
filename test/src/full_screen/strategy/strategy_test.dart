import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('inserting', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      expect(
        easyOverlayState.box.currentEntries[FullScreenDialogManager],
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
        easyOverlayState.box.currentEntries[FullScreenDialogManager],
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
        easyOverlayState.box.currentEntries[FullScreenDialogManager],
        isNull,
      );

      expect(find.byKey(dialogKey), findsNothing);
    });
  });
}
