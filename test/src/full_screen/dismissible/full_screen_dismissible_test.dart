import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create all', () {
    expect(
      () => FullScreenDismiss.tap(),
      returnsNormally,
    );
  });
}
