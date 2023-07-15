import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

final _key = GlobalKey<EasyDialogsOverlayState>();

EasyDialogsOverlayState get easyOverlayState => _key.currentState!;

const dialogKey = ValueKey('dialog');
const testCurve = Curves.linear;

Widget app({Widget? child}) => MaterialApp(
      builder: (context, child) {
        return Material(
          child: EasyDialogsOverlay(
            key: _key,
            initialEntries: [
              EasyOverlayAppEntry(
                builder: (context) => child ?? const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
      home: child != null
          ? Builder(
              builder: (context) {
                return child;
              },
            )
          : null,
    );

AnimationController createTestController() => AnimationController(
      vsync: const TestVSync(),
    );

Future<void> showAndHide(
  WidgetTester widgetTester,
  EasyDialog dialog,
  EasyDialogIdentifier identifier, {
  Duration pumpAndSettleDuration = const Duration(seconds: 3),
}) async {
  await widgetTester.pumpWidget(
    app(),
  );

  easyOverlayState.controller.show(dialog);

  await widgetTester.pumpAndSettle(pumpAndSettleDuration);

  expect(find.byKey(dialogKey), findsOneWidget);

  easyOverlayState.controller.hide(identifier);

  await widgetTester.pumpAndSettle(pumpAndSettleDuration);

  expect(find.byKey(dialogKey), findsNothing);
}
