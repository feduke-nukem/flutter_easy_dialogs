import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_easy_dialogs/src/core/widget/overlay_provider.dart';
import 'package:flutter_test/flutter_test.dart';

final _key = GlobalKey<OverlayProviderState>();

OverlayProviderState get easyOverlayState => _key.currentState!;

const dialogKey = ValueKey('dialog');
const testCurve = Curves.linear;

Widget app({Widget? child}) => MaterialApp(
      builder: (context, child) => OverlayProvider(
        child: child ?? const SizedBox(),
        key: _key,
      ),
      home: child != null ? Builder(builder: (context) => child) : null,
    );

AnimationController createTestController() => AnimationController(
      vsync: const TestVSync(),
    );

Future<void> showAndHide(
  WidgetTester widgetTester,
  EasyDialog dialog, {
  Duration pumpAndSettleDuration = const Duration(seconds: 3),
}) async {
  await widgetTester.pumpWidget(
    app(),
  );

  easyOverlayState.controller.show(dialog);

  await widgetTester.pumpAndSettle(pumpAndSettleDuration);

  expect(find.byKey(dialogKey), findsOneWidget);

  easyOverlayState.controller.hide(id: dialog.id);

  await widgetTester.pumpAndSettle(pumpAndSettleDuration);

  expect(find.byKey(dialogKey), findsNothing);
}
