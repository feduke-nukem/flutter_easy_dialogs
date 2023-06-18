import 'package:flutter_easy_dialogs/src/util/multiply_animation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock.dart';

void main() {
  test('create', () {
    expect(
      () => MultiplyAnimation(first: FakeAnimation(0), next: FakeAnimation(2)),
      returnsNormally,
    );

    final animation =
        MultiplyAnimation(first: FakeAnimation(2), next: FakeAnimation(2));

    expect(animation.value, 4);
  });
}
