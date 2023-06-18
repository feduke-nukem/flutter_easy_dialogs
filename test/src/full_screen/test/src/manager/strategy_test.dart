import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_dialog_manager/src/manager/full_screen_dialog_manager.dart';

import '../../helper.dart';

void main() {
  group('inserting', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      expect(
        easyOverlayState.box.currentEntries[FullScreenConversation],
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
        easyOverlayState.box.currentEntries[FullScreenConversation],
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
        easyOverlayState.box.currentEntries[FullScreenConversation],
        isNull,
      );

      expect(find.byKey(dialogKey), findsNothing);
    });
  });
}
