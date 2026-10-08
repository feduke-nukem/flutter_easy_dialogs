import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  test(
    'create all',
    () {
      expect(() => EasyDialogDismiss.animatedTap(), returnsNormally);
      expect(
        () => EasyDialogDismiss.tap(),
        returnsNormally,
      );
      expect(
        () => EasyDialogDismiss.swipe(),
        returnsNormally,
      );
      expect(
        () => EasyDialogDismiss.tapOutside(),
        returnsNormally,
      );
    },
  );
  testWidgets('show, tap, dismissed, animated tap', (widgetTester) async {
    await widgetTester.pumpWidget(
      app(),
    );
    const position = EasyDialogPosition.top;

    unawaited(
      easyOverlayState.controller.show(
        EasyDialog.positioned(
          decoration: EasyDialogDismiss.animatedTap(),
          content: Text(
            'BANNER',
            key: dialogKey,
            style: TextStyle(fontSize: 30),
          ),
          position: position,
        ),
      ),
    );
    await widgetTester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byKey(dialogKey), findsOneWidget);

    final banner = find.byKey(dialogKey);

    final gesture = await widgetTester.press(banner);

    await gesture.up();

    await widgetTester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byKey(dialogKey), findsNothing);
  });

  testWidgets('show, tap dismissible', (widgetTester) async {
    await widgetTester.pumpWidget(
      app(),
    );
    const position = EasyDialogPosition.top;

    unawaited(
      easyOverlayState.controller.show(
        PositionedDialog(
          autoHideDuration: null,
          decoration: EasyDialogDismiss.tap(),
          content: Text(
            'BANNER',
            key: dialogKey,
            style: TextStyle(fontSize: 30),
          ),
          position: position,
        ),
      ),
    );
    await widgetTester.pumpAndSettle(_pumpAndSettleDuration);

    expect(find.byKey(dialogKey), findsOneWidget);

    final banner = find.byKey(dialogKey);

    await widgetTester.tap(banner);

    await widgetTester.pumpAndSettle(_pumpAndSettleDuration);

    expect(find.byKey(dialogKey), findsNothing);
  });
  testWidgets('show, tap gesture dismissible, but did not dismiss',
      (widgetTester) async {
    await widgetTester.pumpWidget(
      app(),
    );
    const position = EasyDialogPosition.top;

    easyOverlayState.controller.show(
      EasyDialog.positioned(
        autoHideDuration: null,
        decoration: EasyDialogDismiss.tap(
          willDismiss: () => false,
        ),
        content: Text(
          'BANNER',
          key: dialogKey,
          style: TextStyle(fontSize: 30),
        ),
        position: position,
      ),
    );
    await widgetTester.pumpAndSettle(_pumpAndSettleDuration);

    expect(find.byKey(dialogKey), findsOneWidget);

    final banner = find.byKey(dialogKey);

    await widgetTester.tap(banner);

    await widgetTester.pumpAndSettle(_pumpAndSettleDuration);

    expect(find.byKey(dialogKey), findsOneWidget);
  });

  group('tap outside', () {
    Future<Future<Object?>> show(
      WidgetTester widgetTester, {
      EasyWillDismiss? willDismiss,
    }) async {
      await widgetTester.pumpWidget(app());
      final result = easyOverlayState.controller.show(
        const ColoredBox(
          key: dialogKey,
          color: Colors.red,
          child: SizedBox.square(dimension: 50.0),
        )
            .positioned(
              position: EasyDialogPosition.center,
              autoHideDuration: null,
            )
            .tapOutside(onDismissed: () => 1, willDismiss: willDismiss),
      );
      await widgetTester.pumpAndSettle();

      return result;
    }

    testWidgets('tap inside - not dismissed', (widgetTester) async {
      await show(widgetTester);

      await widgetTester.tap(find.byKey(dialogKey), warnIfMissed: false);
      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsOneWidget);
    });

    testWidgets('tap outside - dismissed with result', (widgetTester) async {
      final result = await show(widgetTester);

      await widgetTester.tapAt(Offset.zero);
      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsNothing);
      expect(await result, 1);
    });

    testWidgets('drag outside - not dismissed', (widgetTester) async {
      await show(widgetTester);

      await widgetTester.dragFrom(Offset.zero, const Offset(0.0, 100.0));
      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsOneWidget);
    });

    testWidgets('tap outside, will dismiss false - not dismissed',
        (widgetTester) async {
      await show(widgetTester, willDismiss: () => false);

      await widgetTester.tapAt(Offset.zero);
      await widgetTester.pumpAndSettle();

      expect(find.byKey(dialogKey), findsOneWidget);
    });
  });

  group('swipe', () {
    testWidgets('show, tap, dismissed, horizontal swipe dismissible',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        app(),
      );
      const position = EasyDialogPosition.top;

      unawaited(
        easyOverlayState.controller.show(
          EasyDialog.positioned(
            autoHideDuration: null,
            decoration: EasyDialogDismiss.swipe(),
            content: Text(
              'BANNER',
              key: dialogKey,
              style: TextStyle(fontSize: 30),
            ),
            position: position,
          ),
        ),
      );
      await widgetTester.pumpAndSettle(_pumpAndSettleDuration);

      expect(find.byKey(dialogKey), findsOneWidget);

      final banner = find.byKey(dialogKey);

      await widgetTester.drag(banner, const Offset(500, 0));

      await widgetTester.pumpAndSettle(_pumpAndSettleDuration);

      expect(find.byKey(dialogKey), findsNothing);
    });

    testWidgets('show, tap, dismissed, vertical swipe dismissible',
        (widgetTester) async {
      await widgetTester.pumpWidget(
        app(),
      );
      const position = EasyDialogPosition.top;

      unawaited(
        easyOverlayState.controller.show(
          EasyDialog.positioned(
            autoHideDuration: null,
            decoration: EasyDialogDismiss.swipe(
              direction: DismissDirection.vertical,
            ),
            content: Text(
              'BANNER',
              key: dialogKey,
              style: TextStyle(fontSize: 30),
            ),
            position: position,
          ),
        ),
      );
      await widgetTester.pumpAndSettle(_pumpAndSettleDuration);

      expect(find.byKey(dialogKey), findsOneWidget);

      final banner = find.byKey(dialogKey);

      await widgetTester.drag(banner, const Offset(0, -500));

      await widgetTester.pumpAndSettle(_pumpAndSettleDuration);

      expect(find.byKey(dialogKey), findsNothing);
    });
  });
}

const _pumpAndSettleDuration = Duration(seconds: 3);
