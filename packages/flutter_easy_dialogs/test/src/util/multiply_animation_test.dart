import 'package:flutter_easy_dialogs/src/util/multiply_animation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock.dart';

void main() {
  test('create', () {
    expect(
      () => MultiplyAnimation(first: MockAnimation(0), next: MockAnimation(2)),
      returnsNormally,
    );

    final animation =
        MultiplyAnimation(first: MockAnimation(2), next: MockAnimation(2));

    expect(animation.value, 4);
  });
}
