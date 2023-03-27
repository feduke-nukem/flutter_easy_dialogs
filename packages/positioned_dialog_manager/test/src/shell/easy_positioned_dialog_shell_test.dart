import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:positioned_dialog_manager/src/easy_dialog_position.dart';
import 'package:positioned_dialog_manager/src/shell/positioned_dialog_shell/positioned_dialog_shell.dart';

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
  testGoldens('different parameters', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'padding: all 30, position top',
        const PositionedDialogShell.banner(
          padding: EdgeInsets.all(30.0),
        ).decorate(PositionedDialogShellData(
            position: EasyDialogPosition.top, dialog: _bannerContent)),
      )
      ..addScenario(
        'margin: all 30, position top',
        const PositionedDialogShell.banner(
          margin: EdgeInsets.all(30.0),
        ).decorate(PositionedDialogShellData(
            position: EasyDialogPosition.top, dialog: _bannerContent)),
      )
      ..addScenario(
        'backgroundColor: yellow, position top',
        const PositionedDialogShell.banner(
          backgroundColor: Colors.yellow,
        ).decorate(PositionedDialogShellData(
            position: EasyDialogPosition.top, dialog: _bannerContent)),
      )
      ..addScenario(
        'border radius: 20, position top',
        PositionedDialogShell.banner(
          borderRadius: BorderRadius.circular(20),
        ).decorate(PositionedDialogShellData(
            position: EasyDialogPosition.top, dialog: _bannerContent)),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: (child) => app(child: child),
    );

    await screenMatchesGolden(tester, 'different_parameters');
  });
}
