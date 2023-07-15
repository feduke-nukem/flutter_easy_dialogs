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
}

const _pumpAndSettleDuration = Duration(seconds: 3);
