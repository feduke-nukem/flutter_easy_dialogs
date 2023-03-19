import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
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
  testGoldens('different parameters', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'padding: all 30, position top',
        EasyPositionedDialogShell.banner(
          padding: const EdgeInsets.all(30.0),
        ),
      )
      ..addScenario(
        'margin: all 30, position top',
        EasyPositionedDialogShell.banner(
          margin: const EdgeInsets.all(30.0),
        ),
      )
      ..addScenario(
        'backgroundColor: yellow, position top',
        EasyPositionedDialogShell.banner(
          backgroundColor: Colors.yellow,
        ),
      )
      ..addScenario(
        'border radius: 20, position top',
        EasyPositionedDialogShell.banner(
          borderRadius: BorderRadius.circular(20),
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: (child) => EasyDialogScope(
        data: EasyPositionedScopeData(
            content: _bannerContent, position: EasyDialogPosition.top),
        child: app(child: child),
      ),
    );

    await screenMatchesGolden(tester, 'different_parameters');
  });
}
