import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:positioned_dialog_manager/src/dismissible/positioned_dismissible.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';
import 'package:positioned_dialog_manager/src/manager/positioned_dialog_manager.dart';
import 'package:positioned_dialog_manager/src/util/positioned_dialog_manager_controller_x.dart';

import '../../helper.dart';

void main() {
  test('create', () {
    expect(
      () => PositionedDismissible.swipe(
        onDismissed: () {},
      ),
      returnsNormally,
    );
  });
  testWidgets('show, tap, dismissed, horizontal swipe dismissible',
      (widgetTester) async {
    await widgetTester.pumpWidget(app(
      setupManagers: (overlayController, managerRegistrar) {
        managerRegistrar.register(() =>
            PositionedDialogManager(overlayController: overlayController));
      },
    ));
    const position = EasyDialogPosition.top;

    unawaited(
      easyOverlayState.dialogManagerProvider
          .showPositioned(const PositionedShowParams(
        dismissible: PositionedDismissible.swipe(),
        content: Text(
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

    await widgetTester.drag(banner, const Offset(500, 0));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);
  });

  testWidgets('show, tap, dismissed, vertical swipe dismissible',
      (widgetTester) async {
    await widgetTester.pumpWidget(app(
      setupManagers: (overlayController, managerRegistrar) {
        managerRegistrar.register(() =>
            PositionedDialogManager(overlayController: overlayController));
      },
    ));
    const position = EasyDialogPosition.top;

    unawaited(
      easyOverlayState.dialogManagerProvider
          .showPositioned(const PositionedShowParams(
        dismissible: PositionedDismissible.swipe(
          direction: PositionedDismissibleSwipeDirection.vertical,
        ),
        content: Text(
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

    await widgetTester.drag(banner, const Offset(0, -500));

    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);
  });
}
