import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('inserting', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(
        app(),
      );

      const position = EasyDialogPosition.top;
      const strategy = DefaultEasyOverlayBoxInsertion(
        id: position,
        dialog: SizedBox.shrink(
          key: dialogKey,
        ),
      );

      easyOverlayState.insertDialog(strategy);

      final dialogEntry = easyOverlayState.box.currentEntries[position];

      expect(
        dialogEntry,
        isNotNull,
      );

      expect(dialogEntry!, isA<EasyDialogsOverlayEntry>());

      await widgetTester.pump();

      expect(find.byKey(dialogKey), findsOneWidget);
    });

    testWidgets(
      'insert the same id - throws assertion error',
      (widgetTester) async {
        await widgetTester.pumpWidget(app());
        const strategy = DefaultEasyOverlayBoxInsertion(
          id: EasyDialogPosition.bottom,
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
          (e) => DefaultEasyOverlayBoxInsertion(
            id: e,
            dialog: SizedBox.shrink(
              key: ValueKey(e),
            ),
          ),
        );

        for (var strategy in strategies) {
          easyOverlayState.insertDialog(strategy);
        }

        expect(
          easyOverlayState.box.currentEntries.length,
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
          const DefaultEasyOverlayBoxRemoval(
            id: EasyDialogPosition.bottom,
          ),
        ),
        returnsNormally,
      );
    });
    testWidgets('insert one and remove one', (widgetTester) async {
      await widgetTester.pumpWidget(app());

      const position = EasyDialogPosition.bottom;
      easyOverlayState.insertDialog(
        const DefaultEasyOverlayBoxInsertion(
          id: position,
          dialog: SizedBox.shrink(
            key: dialogKey,
          ),
        ),
      );

      await widgetTester.pump();

      expect(find.byKey(dialogKey), findsOneWidget);

      easyOverlayState.removeDialog(
        const DefaultEasyOverlayBoxRemoval(
          id: position,
        ),
      );

      expect(
        easyOverlayState.box.currentEntries[position],
        isNull,
      );

      expect(
        easyOverlayState.box.currentEntries.length,
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
          (e) => DefaultEasyOverlayBoxInsertion(
            id: e,
            dialog: Container(),
          ),
        );

        final removeStrategies = EasyDialogPosition.values.map(
          (e) => DefaultEasyOverlayBoxRemoval(
            id: e,
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
          easyOverlayState.box.currentEntries.length,
          isZero,
        );
      },
    );
  });
}
