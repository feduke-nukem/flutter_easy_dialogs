import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:full_screen_dialog_manager/src/shell/full_screen_dialog_shell.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../helper.dart';

final _widget = Container(
  alignment: Alignment.center,
  height: 200.0,
  width: 200.0,
  color: Colors.red,
  child: const Text(
    'Modal banner',
    textAlign: TextAlign.center,
  ),
);

void main() {
  testGoldens('different parameters', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'no parameters',
        SizedBox.square(
          dimension: 250,
          child: const FullScreenDialogShell.modalBanner()
              .call(EasyDialogDecoration(dialog: _widget)),
        ),
      )
      ..addScenario(
        'empty box decoration',
        SizedBox.square(
          dimension: 250,
          child: const FullScreenDialogShell.modalBanner()
              .call(EasyDialogDecoration(dialog: _widget)),
        ),
      )
      ..addScenario(
        'padding all 30',
        SizedBox.square(
          dimension: 250,
          child: const FullScreenDialogShell.modalBanner(
            padding: EdgeInsets.all(30),
          ).call(EasyDialogDecoration(dialog: _widget)),
        ),
      )
      ..addScenario(
        'margin all 30',
        SizedBox.square(
          dimension: 250,
          child: const FullScreenDialogShell.modalBanner(
            margin: EdgeInsets.all(30),
          ).call(EasyDialogDecoration(dialog: _widget)),
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: const Size(250, 1200),
      wrapper: (child) => app(child: child),
    );

    await screenMatchesGolden(tester, 'different_parameters');
  });
}
