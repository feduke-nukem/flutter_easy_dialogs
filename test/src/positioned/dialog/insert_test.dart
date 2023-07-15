import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/positioned/dialog/positioned_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('inserting', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(
        app(),
      );

      const position = EasyDialogPosition.top;
      const strategy = PositionedDialogInsert(
        position: position,
        dialog: SizedBox.shrink(
          key: dialogKey,
        ),
      );

      easyOverlayState.insertDialog(strategy);

      var entries = easyOverlayState.box.currentEntries[PositionedDialog];

      expect(
        entries,
        isNotNull,
      );

      expect(
        entries,
        isNotNull,
      );

      expect(entries!, isA<Map<EasyDialogPosition, OverlayEntry>>());

      entries = entries as Map<EasyDialogPosition, OverlayEntry>;

      expect(entries.length, greaterThan(0));

      await widgetTester.pump();

      expect(find.byKey(dialogKey), findsOneWidget);
    });

    testWidgets(
      'insert the same position',
      (widgetTester) async {
        await widgetTester.pumpWidget(app());
        const strategy = PositionedDialogInsert(
          position: EasyDialogPosition.bottom,
          dialog: SizedBox.shrink(),
        );

        easyOverlayState.insertDialog(strategy);

        expect(
          () => easyOverlayState.insertDialog(strategy),
          throwsAssertionError,
        );
      },
    );

    testWidgets(
      'insert all positions',
      (widgetTester) async {
        await widgetTester.pumpWidget(app());

        final strategies = EasyDialogPosition.values.map(
          (e) => PositionedDialogInsert(
            position: e,
            dialog: SizedBox.shrink(
              key: ValueKey(e),
            ),
          ),
        );

        for (var strategy in strategies) {
          easyOverlayState.insertDialog(strategy);
        }

        expect(
          easyOverlayState.box
              .get<Map<EasyDialogPosition, EasyOverlayEntry>>(PositionedDialog)!
              .length,
          EasyDialogPosition.values.length,
        );

        await widgetTester.pump();

        for (var position in EasyDialogPosition.values) {
          expect(find.byKey(ValueKey(position)), findsOneWidget);
        }
      },
    );
  });

  group('removing', () {
    testWidgets('remove without inserting', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      expect(
        () => easyOverlayState.removeDialog(
          const PositionedDialogRemove(
            position: EasyDialogPosition.bottom,
          ),
        ),
        throwsAssertionError,
      );
    });
    testWidgets('insert one and remove one', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      const position = EasyDialogPosition.bottom;
      easyOverlayState.insertDialog(
        const PositionedDialogInsert(
          position: position,
          dialog: SizedBox.shrink(
            key: dialogKey,
          ),
        ),
      );

      await widgetTester.pump();

      expect(find.byKey(dialogKey), findsOneWidget);

      easyOverlayState.removeDialog(
        const PositionedDialogRemove(
          position: position,
        ),
      );

      expect(
        easyOverlayState.box.currentEntries[PositionedDialog],
        isNotNull,
      );

      expect(
        easyOverlayState.box
            .get<Map<EasyDialogPosition, EasyOverlayEntry>>(PositionedDialog)!
            .length,
        isZero,
      );

      await widgetTester.pump();

      expect(find.byKey(dialogKey), findsNothing);
    });

    testWidgets(
      'insert all positions, and remove them',
      (widgetTester) async {
        await widgetTester.pumpWidget(app());

        final insertStrategies = EasyDialogPosition.values.map(
          (e) => PositionedDialogInsert(position: e, dialog: Container()),
        );

        final removeStrategies = EasyDialogPosition.values.map(
          (e) => PositionedDialogRemove(
            position: e,
          ),
        );

        for (var strategy in insertStrategies) {
          easyOverlayState.insertDialog(strategy);
        }

        await widgetTester.pump();
        expect(
          find.byType(Container),
          findsNWidgets(
            EasyDialogPosition.values.length,
          ),
        );

        for (var strategy in removeStrategies) {
          easyOverlayState.removeDialog(strategy);
        }
        await widgetTester.pump();
        expect(
          find.byType(Container),
          findsNothing,
        );
        expect(
          easyOverlayState.box.currentEntries[PositionedDialog],
          isNotNull,
        );

        expect(
          easyOverlayState.box
              .get<Map<EasyDialogPosition, EasyOverlayEntry>>(PositionedDialog)!
              .length,
          isZero,
        );
      },
    );
  });
}
