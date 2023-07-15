import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/full_screen/dialog/full_screen_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('inserting', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      expect(
        easyOverlayState.box.currentEntries[FullScreenDialog],
        isNull,
      );

      easyOverlayState.insertDialog(
        const FullScreenDialogInsert(
          dialog: SizedBox.shrink(
            key: dialogKey,
          ),
        ),
      );

      expect(
        easyOverlayState.box.currentEntries[FullScreenDialog],
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
        const FullScreenDialogInsert(
          dialog: SizedBox.shrink(
            key: dialogKey,
          ),
        ),
      );

      expect(
        () => easyOverlayState.insertDialog(
          const FullScreenDialogInsert(
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
          const FullScreenDialogInsert(
            dialog: SizedBox.shrink(
              key: dialogKey,
            ),
          ),
        )
        ..removeDialog(const FullScreenDialogRemove());

      expect(
        easyOverlayState.box.currentEntries[FullScreenDialog],
        isNull,
      );

      expect(find.byKey(dialogKey), findsNothing);
    });
  });
}
