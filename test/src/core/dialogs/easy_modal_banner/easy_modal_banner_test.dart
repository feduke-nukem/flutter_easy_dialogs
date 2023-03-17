import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/dialogs.dart';
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
          child: EasyModalBanner(
            child: widget,
          ),
        ),
      )
      ..addScenario(
        'empty box decoration',
        SizedBox.square(
          dimension: 250,
          child: EasyModalBanner(
            boxDecoration: const BoxDecoration(),
            child: widget,
          ),
        ),
      )
      ..addScenario(
        'padding all 30',
        SizedBox.square(
          dimension: 250,
          child: EasyModalBanner(
            padding: const EdgeInsets.all(30),
            child: widget,
          ),
        ),
      )
      ..addScenario(
        'margin all 30',
        SizedBox.square(
          dimension: 250,
          child: EasyModalBanner(
            margin: const EdgeInsets.all(30),
            child: widget,
          ),
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
