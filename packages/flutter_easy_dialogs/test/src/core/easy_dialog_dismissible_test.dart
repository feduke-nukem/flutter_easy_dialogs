import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create data', () {
    final dialog = Container();

    expect(
      () => EasyDismissibleData(dialog: dialog),
      returnsNormally,
    );

    final data = EasyDismissibleData(dialog: dialog);

    expect(data.dialog, dialog);
  });
}
