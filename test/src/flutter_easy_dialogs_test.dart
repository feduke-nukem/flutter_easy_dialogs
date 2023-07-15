import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

const _key = Key('dialog');
const _content = SizedBox(
  key: _key,
);

Widget get _app => MaterialApp(
      builder: FlutterEasyDialogs.builder(),
    );

void main() {
  test('create', () {
    expect(() => FlutterEasyDialogs(child: SizedBox.shrink()), returnsNormally);
  });

  testWidgets('wrap app, show and hide', (widgetTester) async {
    await widgetTester.pumpWidget(_app);

    final controller = FlutterEasyDialogs.controller;

    controller.show(
      PositionedDialog(
        content: _content,
      ),
    );

    await widgetTester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(_key), findsOneWidget);

    controller.hide(
      PositionedDialog.identifier(position: EasyDialogPosition.top),
    );

    await widgetTester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(_key), findsNothing);
  });

  testWidgets('show different dialogs. entries correctly reflect',
      (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: FlutterEasyDialogs.builder(),
      ),
    );

    FlutterEasyDialogs.show(
      EasyDialog.positioned(
        content: Container(),
        autoHideDuration: null,
      ),
    );
    await widgetTester.pumpAndSettle(const Duration(seconds: 3));
    FlutterEasyDialogs.show(
      EasyDialog.positioned(
        content: Container(),
        position: EasyDialogPosition.bottom,
        autoHideDuration: null,
      ),
    );

    await widgetTester.pumpAndSettle(const Duration(seconds: 3));

    expect(
      FlutterEasyDialogs.controller.entries.values.every(
        (element) => element.dialog is PositionedDialog,
      ),
      isTrue,
    );
    expect(FlutterEasyDialogs.controller.entries.length, equals(2));

    FlutterEasyDialogs.show(
      EasyDialog.fullScreen(content: Container()),
    );

    await widgetTester.pumpAndSettle(const Duration(seconds: 3));

    expect(FlutterEasyDialogs.controller.entries.length, equals(3));
    expect(
      FlutterEasyDialogs.controller.entries.values.last.dialog,
      isA<FullScreenDialog>(),
    );
  });
  testWidgets('show different and hide where type', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: FlutterEasyDialogs.builder(),
      ),
    );

    FlutterEasyDialogs.show(
      EasyDialog.positioned(
        content: Container(),
        autoHideDuration: null,
      ),
    );
    await widgetTester.pumpAndSettle(const Duration(seconds: 3));
    FlutterEasyDialogs.show(
      EasyDialog.positioned(
        content: Container(),
        position: EasyDialogPosition.bottom,
        autoHideDuration: null,
      ),
    );

    await widgetTester.pumpAndSettle(const Duration(seconds: 3));

    FlutterEasyDialogs.show(FullScreenDialog(content: Container()));

    await widgetTester.pumpAndSettle(const Duration(seconds: 3));

    FlutterEasyDialogs.hideWhereType<PositionedDialog>();

    await widgetTester.pumpAndSettle(const Duration(seconds: 3));

    expect(FlutterEasyDialogs.controller.entries.length, equals(1));
    expect(
      FlutterEasyDialogs.controller.entries.values.first.dialog,
      isA<FullScreenDialog>(),
    );
  });

  testWidgets('show different and hide where', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: FlutterEasyDialogs.builder(),
      ),
    );

    FlutterEasyDialogs.show(
      EasyDialog.positioned(
        content: Container(),
        autoHideDuration: null,
      ),
    );
    await widgetTester.pumpAndSettle(const Duration(seconds: 3));
    FlutterEasyDialogs.show(
      EasyDialog.positioned(
        content: Container(),
        position: EasyDialogPosition.bottom,
        autoHideDuration: null,
      ),
    );

    await widgetTester.pumpAndSettle(const Duration(seconds: 3));

    FlutterEasyDialogs.show(
      EasyDialog.fullScreen(content: Container()),
    );

    await widgetTester.pumpAndSettle(const Duration(seconds: 3));

    FlutterEasyDialogs.hideWhere<PositionedDialog>(
      (element) => element.position == EasyDialogPosition.bottom,
    );

    await widgetTester.pumpAndSettle(const Duration(seconds: 3));

    expect(FlutterEasyDialogs.controller.entries.length, equals(2));
    expect(
      FlutterEasyDialogs.controller.entries.values.first.dialog,
      isA<PositionedDialog>(),
    );
    expect(
      (FlutterEasyDialogs.controller.entries.values.first.dialog
              as PositionedDialog)
          .position,
      EasyDialogPosition.top,
    );
    expect(
      FlutterEasyDialogs.controller.entries.values.last.dialog,
      isA<FullScreenDialog>(),
    );
  });

  testWidgets(
    'show and hide with result',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          builder: FlutterEasyDialogs.builder(),
        ),
      );

      int? result;

      FlutterEasyDialogs.show<int>(
        EasyDialog.fullScreen(
          content: Container(),
        ),
      ).then((value) => result = value);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      FlutterEasyDialogs.hide(FullScreenDialog.identifier(), result: 9);

      await widgetTester.pumpAndSettle(const Duration(seconds: 3));

      expect(result, equals(9));
    },
  );
}
