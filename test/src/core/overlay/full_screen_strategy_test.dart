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
          dialog: const SizedBox.shrink(),
        ),
      );

      expect(
        easyOverlayState
            .currentEntries[EasyOverlayEntriesAccessKeys.fullScreen],
        isNotNull,
      );
    });
  });

  testWidgets(
    'inserted twice',
    (widgetTester) async {
      await widgetTester.pumpWidget(app);

      easyOverlayState.insertDialog(
        EasyOverlayInsertStrategy.fullScreen(
          dialog: const SizedBox.shrink(),
        ),
      );

      expect(
        () => easyOverlayState.insertDialog(
          EasyOverlayInsertStrategy.fullScreen(
            dialog: const SizedBox.shrink(),
          ),
        ),
        throwsAssertionError,
      );
    },
  );

  group('removing', () {
    testWidgets('insert and remove', (widgetTester) async {
      await widgetTester.pumpWidget(app);

      easyOverlayState
        ..insertDialog(
          EasyOverlayInsertStrategy.fullScreen(
            dialog: const SizedBox.shrink(),
          ),
        )
        ..removeDialog(EasyOverlayRemoveStrategy.fullScreen());

      expect(
        easyOverlayState
            .currentEntries[EasyOverlayEntriesAccessKeys.fullScreen],
        isNull,
      );
    });
  });
}
