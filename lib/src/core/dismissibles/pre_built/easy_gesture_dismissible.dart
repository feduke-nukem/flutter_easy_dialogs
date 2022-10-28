import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class EasyGestureDismissible extends EasyDismissible {
  EasyGestureDismissible({required super.onDismissed});

  @override
  Widget makeDismissible(Widget child) {
    return GestureDetector(
      onTap: super.onDismissed,
      child: child,
    );
  }
}
