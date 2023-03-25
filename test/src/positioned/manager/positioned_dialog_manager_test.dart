import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';
import 'package:flutter_easy_dialogs/src/positioned/manager/positioned_dialog_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helper.dart';

final _bannerContent = ElevatedButton(
  key: dialogKey,
  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
  onPressed: () {},
  child: const Text(
    'BANNER',
    style: TextStyle(fontSize: 30),
  ),
);

void main() {
  group('showing', () {
    testWidgets('show at top', (tester) async {
      await tester.pumpWidget(app());

      unawaited(
        easyOverlayState.easyDialogsController.showPositioned(
            params: PositionedShowParams(
          content: _bannerContent,
          position: EasyDialogPosition.top,
        )),
      );

      expect(easyOverlayState.box.currentEntries.isNotEmpty, isTrue);
      expect(
          easyOverlayState.box
              .get<Map<EasyDialogPosition, OverlayEntry>>(
                  PositionedDialogManager)!
              .length,
          1);
      expect(
          easyOverlayState.box.get<Map<EasyDialogPosition, OverlayEntry>>(
              PositionedDialogManager)![EasyDialogPosition.top],
          isA<EasyDialogsOverlayEntry>());

      await tester.pumpAndSettle();
    });

    testWidgets('show and hide at top', (tester) async {
      await tester.pumpWidget(app());

      unawaited(
        easyOverlayState.easyDialogsController.showPositioned(
            params: PositionedShowParams(
          content: _bannerContent,
          position: EasyDialogPosition.top,
        )),
      );
      await tester.pumpAndSettle();

      unawaited(
        easyOverlayState.easyDialogsController.hidePositioned(
          position: EasyDialogPosition.top,
        ),
      );
      await tester.pumpAndSettle();

      expect(
          easyOverlayState.box
              .get<Map<EasyDialogPosition, OverlayEntry>>(
                  PositionedDialogManager)!
              .length,
          isZero);
      expect(
          easyOverlayState.box.get<Map<EasyDialogPosition, OverlayEntry>>(
              PositionedDialogManager)![EasyDialogPosition.top],
          isNull);

      await tester.pumpAndSettle();
    });

    testWidgets('show at all positions, hide at center, then hide all',
        (tester) async {
      await tester.pumpWidget(app());

      for (var position in EasyDialogPosition.values) {
        unawaited(
          easyOverlayState.easyDialogsController.showPositioned(
              params: PositionedShowParams(
            content: _bannerContent,
            position: position,
          )),
        );
      }

      await tester.pumpAndSettle();

      expect(
          easyOverlayState.box
              .get<Map<EasyDialogPosition, OverlayEntry>>(
                  PositionedDialogManager)!
              .length,
          EasyDialogPosition.values.length);

      for (var position in EasyDialogPosition.values) {
        expect(
            easyOverlayState.box.get<Map<EasyDialogPosition, OverlayEntry>>(
                PositionedDialogManager)![position],
            isA<EasyDialogsOverlayEntry>());
      }

      expect(find.byKey(dialogKey), findsNWidgets(3));

      unawaited(
        easyOverlayState.easyDialogsController.hidePositioned(
          position: EasyDialogPosition.center,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsNWidgets(2));
      expect(
          easyOverlayState.box
              .get<Map<EasyDialogPosition, OverlayEntry>>(
                  PositionedDialogManager)!
              .length,
          EasyDialogPosition.values.length - 1);

      expect(
          easyOverlayState.box.get<Map<EasyDialogPosition, OverlayEntry>>(
              PositionedDialogManager)![EasyDialogPosition.center],
          isNull);

      unawaited(
        easyOverlayState.easyDialogsController.hideAllPositioned(),
      );

      await tester.pumpAndSettle();

      for (var position in EasyDialogPosition.values) {
        expect(
            easyOverlayState.box.get<Map<EasyDialogPosition, OverlayEntry>>(
                PositionedDialogManager)![position],
            isNull);
      }

      expect(
          easyOverlayState.box
              .get<Map<EasyDialogPosition, OverlayEntry>>(
                  PositionedDialogManager)!
              .length,
          isZero);

      expect(find.byKey(dialogKey), findsNothing);
    });
  });

  group('animator configuring', () {});

  group('dismissing', () {
    testWidgets('show, tap, dismissed, tap dismissible', (widgetTester) async {
      await widgetTester.pumpWidget(app());
      final position = EasyDialogPosition.top;

      unawaited(
        easyOverlayState.easyDialogsController.showPositioned(
            params: PositionedShowParams(
          dismissible: PositionedDismissible.tap(),
          content: const Text(
            'BANNER',
            key: dialogKey,
            style: TextStyle(fontSize: 30),
          ),
          position: position,
        )),
      );
      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsOneWidget);

      final banner = find.byKey(dialogKey);

      await widgetTester.tap(banner);

      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsNothing);
    });

    testWidgets('show, tap, dismissed, swipe dismissible',
        (widgetTester) async {
      await widgetTester.pumpWidget(app());
      final position = EasyDialogPosition.top;

      unawaited(
        easyOverlayState.easyDialogsController.showPositioned(
            params: PositionedShowParams(
          dismissible: PositionedDismissible.horizontalSwipe(),
          content: const Text(
            'BANNER',
            key: dialogKey,
            style: TextStyle(fontSize: 30),
          ),
          position: position,
        )),
      );
      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsOneWidget);

      final banner = find.byKey(dialogKey);

      await widgetTester.drag(banner, Offset(500, 0));

      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsNothing);
    });

    testWidgets('show, tap, dismissed, gesture dismissible',
        (widgetTester) async {
      await widgetTester.pumpWidget(app());
      final position = EasyDialogPosition.top;

      unawaited(
        easyOverlayState.easyDialogsController.showPositioned(
            params: PositionedShowParams(
          dismissible: PositionedDismissible.gesture(),
          content: const Text(
            'BANNER',
            key: dialogKey,
            style: TextStyle(fontSize: 30),
          ),
          position: position,
        )),
      );
      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsOneWidget);

      final banner = find.byKey(dialogKey);

      await widgetTester.tap(banner);

      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsNothing);
    });

    testWidgets('show, no dismissible', (widgetTester) async {
      await widgetTester.pumpWidget(app());
      final position = EasyDialogPosition.top;

      unawaited(
        easyOverlayState.easyDialogsController.showPositioned(
            params: PositionedShowParams(
          dismissible: PositionedDismissible.none(),
          content: const Text(
            'BANNER',
            key: dialogKey,
            style: TextStyle(fontSize: 30),
          ),
          position: position,
        )),
      );
      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsOneWidget);

      final banner = find.byKey(dialogKey);

      await widgetTester.tap(banner);

      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsOneWidget);
    });
  });

  testWidgets('show, auto hide after four second ', (widgetTester) async {
    await widgetTester.pumpWidget(app());
    final position = EasyDialogPosition.top;

    unawaited(
      easyOverlayState.easyDialogsController.showPositioned(
          params: PositionedShowParams(
        dismissible: PositionedDismissible.none(),
        autoHideDuration: const Duration(seconds: 4),
        content: const Text(
          'BANNER',
          key: dialogKey,
          style: TextStyle(fontSize: 30),
        ),
        position: position,
      )),
    );
    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);

    await widgetTester.pump(
      const Duration(seconds: 3),
    );

    expect(find.byKey(dialogKey), findsOneWidget);

    await widgetTester.pumpAndSettle(
      const Duration(seconds: 1),
    );

    expect(find.byKey(dialogKey), findsNothing);
  });
}
