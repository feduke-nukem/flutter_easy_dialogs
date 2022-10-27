import 'package:flutter/material.dart';

typedef EasyDismissCallback = void Function();

abstract class EasyDismissible implements IEasyDismissor {
  final EasyDismissCallback onDismissed;

  const EasyDismissible({
    required this.onDismissed,
  });
}

abstract class IEasyDismissor {
  Widget makeDismissible(Widget child);
}
