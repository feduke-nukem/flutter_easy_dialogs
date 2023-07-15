import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('markNeedsRebuild called', () {
    final entry = _DummyEntry(builder: (_) => Container());

    expect(() => entry.markNeedsBuild(), throwsFlutterError);
  });
}

final class _DummyEntry extends EasyOverlayEntry {
  _DummyEntry({required super.builder});
}
