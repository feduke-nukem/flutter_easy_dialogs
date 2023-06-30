import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismiss.dart';
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

  test('create', () {
    expect(() => _DummyDismissible(onDismissed: () {}), returnsNormally);
  });

  test('create payload', () {
    expect(() => EasyDismissiblePayload(), returnsNormally);

    final payload = EasyDismissiblePayload(instantDismiss: true);

    expect(payload.instantDismiss, isTrue);
  });
}

final class _DummyDismissible extends EasyDialogDismiss {
  const _DummyDismissible({super.handleDismiss});

  @override
  Widget call(EasyDismissibleData<EasyDismissiblePayload> data) => data.dialog;
}
