import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/overlay/overlay.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('inserting', () {
    testWidgets('insert', (widgetTester) async {
      await widgetTester.pumpWidget(app);

      const position = EasyDialogPosition.top;
      final strategy = EasyOverlayInsertStrategy.positioned(
        position: position,
        dialog: const SizedBox.shrink(),
      );

      easyOverlayState.insertDialog(strategy);

      var entries = easyOverlayState
          .currentEntries[EasyOverlayEntriesAccessKeys.positioned];

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
    });

    testWidgets(
      'insert the same position',
      (widgetTester) async {
        await widgetTester.pumpWidget(app);
        final strategy = EasyOverlayInsertStrategy.positioned(
          position: EasyDialogPosition.bottom,
          dialog: const SizedBox.shrink(),
        );

        easyOverlayState.insertDialog(strategy);

        expect(() => easyOverlayState.insertDialog(strategy),
            throwsAssertionError);
      },
    );

    testWidgets(
      'insert all positions',
      (widgetTester) async {
        await widgetTester.pumpWidget(app);

        final strategies = EasyDialogPosition.values.map(
          (e) => EasyOverlayInsertStrategy.positioned(
            position: e,
            dialog: const SizedBox.shrink(),
          ),
        );

        for (var strategy in strategies) {
          easyOverlayState.insertDialog(strategy);
        }

        expect(
          EasyOverlayEntriesInsertAccessor.positioned(easyOverlayState).length,
          EasyDialogPosition.values.length,
        );
      },
    );
  });

  group('removing', () {
    testWidgets('remove without inserting', (widgetTester) async {
      await widgetTester.pumpWidget(app);

      expect(
        () => easyOverlayState.removeDialog(
          EasyOverlayRemoveStrategy.positioned(
            position: EasyDialogPosition.bottom,
          ),
        ),
        throwsAssertionError,
      );
    });
    testWidgets('insert one and remove one', (widgetTester) async {
      await widgetTester.pumpWidget(app);

      const position = EasyDialogPosition.bottom;
      easyOverlayState
        ..insertDialog(
          EasyOverlayInsertStrategy.positioned(
            position: position,
            dialog: const SizedBox.shrink(),
          ),
        )
        ..removeDialog(
          EasyOverlayRemoveStrategy.positioned(
            position: position,
          ),
        );

      expect(
        easyOverlayState
            .currentEntries[EasyOverlayEntriesAccessKeys.positioned],
        isNotNull,
      );

      expect(
        (EasyOverlayEntriesRawAccessor.positioned(easyOverlayState)).length,
        isZero,
      );
    });

    testWidgets(
      'insert all positions, and remove them',
      (widgetTester) async {
        await widgetTester.pumpWidget(app);

        final insertStrategies = EasyDialogPosition.values.map(
          (e) => EasyOverlayInsertStrategy.positioned(
            position: e,
            dialog: const SizedBox.shrink(),
          ),
        );

        final removeStrategies = EasyDialogPosition.values.map(
          (e) => EasyOverlayRemoveStrategy.positioned(
            position: e,
          ),
        );

        for (var strategy in insertStrategies) {
          easyOverlayState.insertDialog(strategy);
        }

        for (var strategy in removeStrategies) {
          easyOverlayState.removeDialog(strategy);
        }

        expect(
          easyOverlayState
              .currentEntries[EasyOverlayEntriesAccessKeys.positioned],
          isNotNull,
        );

        expect(
          (EasyOverlayEntriesRawAccessor.positioned(easyOverlayState)).length,
          isZero,
        );
      },
    );
  });
}
