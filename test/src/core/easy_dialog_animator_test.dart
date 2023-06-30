import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

void main() {
  test(
    'create',
    () => expect(() => _DummyAnimator(curve: Curves.bounceIn), returnsNormally),
  );

  test('decorate', () {
    final parent = createTestController();
    final dialog = Container();
    final animator = _DummyAnimator(curve: Curves.bounceIn);
    expect(
      () => animator.call(EasyDialogAnimation(
        parent: parent,
        dialog: dialog,
      )),
      returnsNormally,
    );
  });

  test('create data', () {
    final parent = createTestController();
    final dialog = Container();

    expect(
      () => EasyDialogAnimation(
        parent: parent,
        dialog: dialog,
      ),
      returnsNormally,
    );

    final data = EasyDialogAnimation(parent: parent, dialog: dialog);

    expect(data.parent, parent);
    expect(data.dialog, dialog);
  });
}

final class _DummyAnimator extends EasyDialogAnimation {
  const _DummyAnimator({super.curve});

  @override
  Widget call(EasyDialogAnimation data) => data.dialog;
}
