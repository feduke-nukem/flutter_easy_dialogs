import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helper.dart';

const _key = Key('dialog');
const _content = SizedBox(
  key: _key,
);

Widget get _app => MaterialApp(
      builder: FlutterEasyDialogs.builder(
        setupManagers: (overlayController, managerRegistry) {
          managerRegistry.register(
              () => TestDialogManager(overlayController: overlayController));
        },
      ),
    );

void main() {
  test('create', () {
    expect(() => FlutterEasyDialogs(child: SizedBox.shrink()), returnsNormally);
  });

  testWidgets('wrap app, show and hide', (widgetTester) async {
    await widgetTester.pumpWidget(_app);

    final manager = FlutterEasyDialogs.provider.use<TestDialogManager>();

    manager.show(params: EasyDialogManagerShowParams(content: _content));

    await widgetTester.pump();

    expect(find.byKey(_key), findsOneWidget);

    manager.hide();

    await widgetTester.pump();

    expect(find.byKey(_key), findsNothing);
  });
}
