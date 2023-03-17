import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../../../helper.dart';

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
  testGoldens('show postponed at top', (tester) async {
    await tester.pumpWidget(app());

    unawaited(
      easyOverlayState.easyDialogsController.showBanner(
        content: _bannerContent,
      ),
    );

    await tester.pump();

    expect(find.byKey(dialogKey), findsOneWidget);
    await multiScreenGolden(tester, 'easy_banner_multi_screen_positioned_top');
  });

  testGoldens('show postponed at bottom', (tester) async {
    await tester.pumpWidget(app());

    unawaited(
      easyOverlayState.easyDialogsController.showBanner(
        content: _bannerContent,
        position: EasyDialogPosition.bottom,
      ),
    );

    await tester.pump();

    expect(find.byKey(dialogKey), findsOneWidget);
    await multiScreenGolden(
      tester,
      'easy_banner_multi_screen_positioned_bottom',
    );
  });

  testGoldens('show postponed at center', (tester) async {
    await tester.pumpWidget(app());

    unawaited(
      easyOverlayState.easyDialogsController.showBanner(
        content: _bannerContent,
        position: EasyDialogPosition.center,
      ),
    );

    await tester.pump();

    expect(find.byKey(dialogKey), findsOneWidget);
    await multiScreenGolden(
      tester,
      'multi_screen_positioned_center',
    );
  });

  testGoldens('different parameters', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'padding: all 30, position top',
        EasyBanner(
          position: EasyDialogPosition.top,
          padding: const EdgeInsets.all(30.0),
          child: _bannerContent,
        ),
      )
      ..addScenario(
        'margin: all 30, position top',
        EasyBanner(
          position: EasyDialogPosition.top,
          margin: const EdgeInsets.all(30.0),
          child: _bannerContent,
        ),
      )
      ..addScenario(
        'backgroundColor: yellow, position top',
        EasyBanner(
          position: EasyDialogPosition.top,
          backgroundColor: Colors.yellow,
          child: _bannerContent,
        ),
      )
      ..addScenario(
        'border radius: 20, position top',
        EasyBanner(
          position: EasyDialogPosition.top,
          borderRadius: BorderRadius.circular(20),
          child: _bannerContent,
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: (child) => app(child: child),
    );

    await screenMatchesGolden(tester, 'different_parameters');
  });
}
