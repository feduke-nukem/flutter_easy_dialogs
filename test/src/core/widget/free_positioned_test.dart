import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/widget/free_positioned.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('drag and position changes', (widgetTester) async {
    final key = GlobalKey();
    final widget = Container(
      height: 100,
      width: 100,
      color: Colors.red,
      key: key,
    );
    await widgetTester.pumpWidget(
      MaterialApp(
        home: FreePositioned(child: widget),
      ),
    );

    expect(find.byKey(key), findsOneWidget);

    final box = key.currentContext!.findRenderObject() as RenderBox;
    final positionBeforeDrag = box.localToGlobal(Offset.zero);

    await widgetTester.drag(find.byKey(key), const Offset(10, 10));
    await widgetTester.pumpAndSettle();

    final positionAfterDrag = box.localToGlobal(Offset.zero);

    expect(positionBeforeDrag, isNot(equals(positionAfterDrag)));
  });
}
