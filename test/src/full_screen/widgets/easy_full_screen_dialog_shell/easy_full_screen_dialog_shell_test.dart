import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_scope.dart';
import 'package:flutter_easy_dialogs/src/full_screen/widgets/easy_full_screen_dialog_shell/easy_full_screen_dialog_shell.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../../../helper.dart';

void main() {
  final widget = Container(
    alignment: Alignment.center,
    height: 200.0,
    width: 200.0,
    color: Colors.red,
    child: const Text(
      'Modal banner',
      textAlign: TextAlign.center,
    ),
  );

  testGoldens('different parameters', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'no parameters',
        SizedBox.square(
          dimension: 250,
          child: EasyFullScreenDialogShell.modalBanner(),
        ),
      )
      ..addScenario(
        'empty box decoration',
        SizedBox.square(
          dimension: 250,
          child: EasyFullScreenDialogShell.modalBanner(),
        ),
      )
      ..addScenario(
        'padding all 30',
        SizedBox.square(
          dimension: 250,
          child: EasyFullScreenDialogShell.modalBanner(
            padding: const EdgeInsets.all(30),
          ),
        ),
      )
      ..addScenario(
        'margin all 30',
        SizedBox.square(
          dimension: 250,
          child: EasyFullScreenDialogShell.modalBanner(
            margin: const EdgeInsets.all(30),
          ),
        ),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      surfaceSize: const Size(250, 1200),
      wrapper: (child) => EasyDialogScope(
          data: EasyFullScreenScopeData(content: widget),
          child: app(
            child: child,
          )),
    );

    await screenMatchesGolden(tester, 'different_parameters');
  });
}
