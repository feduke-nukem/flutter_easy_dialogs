import 'package:flutter_easy_dialogs/src/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EasyDialogsOverlayBox sut;

  setUp(() {
    sut = EasyDialogsOverlayBox();
  });

  group('easy overlay box', () {
    test('create box', () {
      expect(() => EasyDialogsOverlayBox(), returnsNormally);
    });

    test('insert int with string key', () {
      sut.put('key', 5);

      expect(sut.currentEntries.length, 1);
      expect(sut.get('key'), isNotNull);
      expect(sut.get('key'), 5);
    });

    test('insert and remove', () {
      sut.put('key', 5);

      final result = sut.remove('key');

      expect(result, 5);
      expect(sut.currentEntries.isEmpty, isTrue);
      expect(sut.get('key'), isNull);
    });
  });
}
