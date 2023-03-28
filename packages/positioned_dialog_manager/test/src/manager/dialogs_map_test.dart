import 'package:flutter_test/flutter_test.dart';
import 'package:positioned_dialog_manager/positioned_dialog_manager.dart';
import 'package:positioned_dialog_manager/src/manager/positioned_dialog_manager.dart';

import '../../helper.dart';

void main() {
  test('create', () {
    expect(() => DialogsMap(), returnsNormally);
  });

  test('insert', () {
    final map = DialogsMap();
    const position = EasyDialogPosition.top;

    expect(map.isEmpty, isTrue);
    expect(map.isNotEmpty, isFalse);
    expect(map.entries.length, isZero);

    map.addController(position, createTestController());

    expect(map.isEmpty, isFalse);
    expect(map.isNotEmpty, isTrue);
    expect(map.entries.length, 1);

    var controller = map.getController(position);

    expect(controller, isNotNull);

    map.removeController(position);

    expect(map.isEmpty, isTrue);
    expect(map.isNotEmpty, isFalse);
    expect(map.entries.length, isZero);

    controller = map.getController(position);

    expect(controller, isNull);
  });

  test('insert multiple and clear', () {
    final map = DialogsMap();

    map.addController(EasyDialogPosition.bottom, createTestController());
    map.addController(EasyDialogPosition.top, createTestController());

    expect(map.entries.length, 2);

    map.clear();

    expect(map.entries.length, 0);
    expect(map.isEmpty, isTrue);
    expect(map.isNotEmpty, isFalse);
  });
}
