import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  testWidgets('show and hide all positions', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: FlutterEasyDialogs.builder(),
      ),
    );

    for (final position in EasyDialogPosition.values) {
      FlutterEasyDialogs.show(
        EasyDialog.positioned(
          id: position,
          decoration: PositionedShell.banner()
              .chained(EasyDialogAnimation.fade())
              .chained(EasyDialogDismiss.tap())
              .chained(
                EasyDialogAnimation.slideVertical(),
              ),
          content: Container(
            key: dialogKey,
          ),
          position: position,
          autoHideDuration: null,
        ),
      );
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byKey(dialogKey), findsOneWidget);
      FlutterEasyDialogs.hide(id: position);
      await widgetTester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.byKey(dialogKey), findsNothing);
    }
  });

  test('clone', () {
    const id = 'id';
    final dialog = PositionedDialog(
      content: const SizedBox.shrink(),
      id: id,
      animationConfiguration: EasyDialogAnimationConfiguration.bounded(
        startValue: 0.0,
        lowerBound: 0.0,
        upperBound: 1.0,
      ),
      autoHideDuration: Duration(seconds: 1),
      decoration: EasyDialogAnimation.bounce(),
    );
    final cloned = dialog.clone() as PositionedDialog;

    expect(cloned.id, id);
    expect(cloned.content, dialog.content);
    expect(cloned.position, dialog.position);
    expect(cloned.animationConfiguration, dialog.animationConfiguration);
    expect(cloned.autoHideDuration, dialog.autoHideDuration);
    expect(cloned.decoration, dialog.decoration);
  });

  test('create with id', () {
    const id = 'id';
    final dialog = PositionedDialog(
      content: const SizedBox.shrink(),
      id: id,
    );

    expect(dialog.id, id);
  });

  test('create without id', () {
    final dialog = PositionedDialog(
      content: const SizedBox.shrink(),
    );

    expect(dialog.id, dialog.position);
  });
}
