import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_decorator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create', () {
    expect(() => _DummyDecorator(), returnsNormally);
  });

  test('decorate', () {
    final decorator = _DummyDecorator();
    final data = EasyDialogDecoratorData(
        dialog: Container(
      key: Key('key'),
    ));

    expect(() => decorator.decorate(data), returnsNormally);
    final dialog = decorator.decorate(data);
    expect(
      dialog.key,
      Key('key'),
    );
  });

  test('create data', () {
    final dialog = Container();

    expect(
      () => EasyDialogDecoratorData(dialog: dialog),
      returnsNormally,
    );

    final data = EasyDialogDecoratorData(dialog: dialog);

    expect(data.dialog, dialog);
  });

  test('combine with empty decorators', () {
    expect(
      () => EasyDialogDecorator.combine<EasyDialogDecoratorData>(
        decorators: [],
        nextDataBuilder: (_, __) => EasyDialogDecoratorData(
          dialog: Container(),
        ),
      ),
      throwsAssertionError,
    );
  });

  test('combine', () {
    expect(
      () => EasyDialogDecorator.combine<EasyDialogDecoratorData>(
        decorators: [
          _DummyDecorator(),
          _DummyDecorator(),
        ],
        nextDataBuilder: (newDialog, __) => EasyDialogDecoratorData(
          dialog: newDialog,
        ),
      ),
      returnsNormally,
    );
  });

  test('decorate combined', () {
    final decorator = EasyDialogDecorator.combine<EasyDialogDecoratorData>(
      decorators: [
        _DummyDecorator(),
        _DummyDecorator(),
      ],
      nextDataBuilder: (newDialog, __) => EasyDialogDecoratorData(
        dialog: newDialog,
      ),
    );

    expect(
      () => decorator.decorate(EasyDialogDecoratorData(
        dialog: Container(),
      )),
      returnsNormally,
    );
  });
}

class _DummyDecorator extends EasyDialogDecorator<EasyDialogDecoratorData> {
  const _DummyDecorator();

  @override
  Widget decorate(EasyDialogDecoratorData data) => data.dialog;
}
