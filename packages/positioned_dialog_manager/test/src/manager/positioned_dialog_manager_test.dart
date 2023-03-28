import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:positioned_dialog_manager/src/dismissible/positioned_dismissible.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';
import 'package:positioned_dialog_manager/src/manager/positioned_dialog_manager.dart';
import 'package:positioned_dialog_manager/src/util/positioned_dialog_manager_controller_x.dart';

import '../../helper.dart';

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
      await tester.pumpWidget(app(
        setupManagers: (overlayController, managerRegistrar) {
          managerRegistrar.register(() =>
              PositionedDialogManager(overlayController: overlayController));
        },
      ));

      unawaited(
        easyOverlayState.dialogManagerProvider
            .showPositioned(PositionedShowParams(
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
    testWidgets('show at top twice', (tester) async {
      await tester.pumpWidget(app(
        setupManagers: (overlayController, managerRegistrar) {
          managerRegistrar.register(() =>
              PositionedDialogManager(overlayController: overlayController));
        },
      ));

      unawaited(
        easyOverlayState.dialogManagerProvider
            .showPositioned(PositionedShowParams(
          content: _bannerContent,
          position: EasyDialogPosition.top,
        )),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(dialogKey), findsOneWidget);

      const key = Key('value');
      unawaited(
        easyOverlayState.dialogManagerProvider
            .showPositioned(PositionedShowParams(
          content: Container(key: key),
          position: EasyDialogPosition.top,
        )),
      );

      await tester.pumpAndSettle();
      expect(find.byKey(dialogKey), findsNothing);
      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('show and hide at top', (tester) async {
      await tester.pumpWidget(app(
        setupManagers: (overlayController, managerRegistrar) {
          managerRegistrar.register(() =>
              PositionedDialogManager(overlayController: overlayController));
        },
      ));

      unawaited(
        easyOverlayState.dialogManagerProvider
            .showPositioned(PositionedShowParams(
          content: _bannerContent,
          position: EasyDialogPosition.top,
        )),
      );
      await tester.pumpAndSettle();

      unawaited(
        easyOverlayState.dialogManagerProvider
            .hidePositioned(EasyDialogPosition.top),
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
      await tester.pumpWidget(app(
        setupManagers: (overlayController, managerRegistrar) {
          managerRegistrar.register(() =>
              PositionedDialogManager(overlayController: overlayController));
        },
      ));

      for (var position in EasyDialogPosition.values) {
        unawaited(
          easyOverlayState.dialogManagerProvider
              .showPositioned(PositionedShowParams(
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
        easyOverlayState.dialogManagerProvider
            .hidePositioned(EasyDialogPosition.center),
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
        easyOverlayState.dialogManagerProvider.hideAllPositioned(),
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

  testWidgets('show, auto hide after four second ', (widgetTester) async {
    await widgetTester.pumpWidget(app(
      setupManagers: (overlayController, managerRegistrar) {
        expect(
            () => managerRegistrar.register(() =>
                PositionedDialogManager(overlayController: overlayController)),
            returnsNormally);
      },
    ));
    const position = EasyDialogPosition.top;

    unawaited(
      easyOverlayState.dialogManagerProvider
          .showPositioned(const PositionedShowParams(
        dismissible: PositionedDismissible.none(),
        hideAfterDuration: Duration(seconds: 4),
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
