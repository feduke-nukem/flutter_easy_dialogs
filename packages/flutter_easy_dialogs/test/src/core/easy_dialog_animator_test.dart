import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  test('create data', () {
    final parent = createTestController();
    final dialog = Container();

    expect(
      () => EasyDialogAnimatorData(
        parent: parent,
        dialog: dialog,
      ),
      returnsNormally,
    );

    final data = EasyDialogAnimatorData(parent: parent, dialog: dialog);

    expect(data.parent, parent);
    expect(data.dialog, dialog);
  });
}
