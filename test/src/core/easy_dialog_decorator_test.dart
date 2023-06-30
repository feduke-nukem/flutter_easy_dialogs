import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decoration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create', () {
    expect(() => _DummyDecorator(), returnsNormally);
  });

  test('decorate', () {
    final decorator = _DummyDecorator();
    final data = EasyDialogDecoration(
        dialog: Container(
      key: Key('key'),
    ));

    expect(() => decorator.call(data), returnsNormally);
    final dialog = decorator.call(data);
    expect(
      dialog.key,
      Key('key'),
    );
  });

  test('create data', () {
    final dialog = Container();

    expect(
      () => EasyDialogDecoration(dialog: dialog),
      returnsNormally,
    );

    final data = EasyDialogDecoration(dialog: dialog);

    expect(data.dialog, dialog);
  });

  test('combine with empty decorators', () {
    expect(
      () => EasyDialogDecoration.combine<EasyDialogDecoration>(
        decorators: [],
        nextDataBuilder: (_, __) => EasyDialogDecoration(
          dialog: Container(),
        ),
      ),
      throwsAssertionError,
    );
  });

  test('combine', () {
    expect(
      () => EasyDialogDecoration.combine<EasyDialogDecoration>(
        decorators: [
          _DummyDecorator(),
          _DummyDecorator(),
        ],
        nextDataBuilder: (newDialog, __) => EasyDialogDecoration(
          dialog: newDialog,
        ),
      ),
      returnsNormally,
    );
  });

  test('decorate combined', () {
    final decorator = EasyDialogDecoration.combine<EasyDialogDecoration>(
      decorators: [
        _DummyDecorator(),
        _DummyDecorator(),
      ],
      nextDataBuilder: (newDialog, __) => EasyDialogDecoration(
        dialog: newDialog,
      ),
    );

    expect(
      () => decorator.call(EasyDialogDecoration(
        dialog: Container(),
      )),
      returnsNormally,
    );
  });
}

final class _DummyDecorator extends EasyDialogDecoration<EasyDialogDecoration> {
  const _DummyDecorator();

  @override
  Widget call(EasyDialogDecoration data) => data.dialog;
}
