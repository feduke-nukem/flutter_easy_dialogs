import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

const _pumpAndSettleDuration = Duration(seconds: 3);

void main() {
  test('create', () {
    expect(
      () => PositionedDismiss.swipe(),
      returnsNormally,
    );
  });
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
          decoration: PositionedDismiss.swipe(),
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
          decoration: PositionedDismiss.swipe(
            direction: PositionedDismissibleSwipeDirection.vertical,
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
}
