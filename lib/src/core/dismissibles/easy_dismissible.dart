import 'package:flutter/material.dart';

/// Dismiss callback
typedef EasyDismissCallback = void Function();

/// Core class of dismissible
abstract class EasyDismissible implements IEasyDismissor {
  /// Callback that fires when dialog get dismissed
  final EasyDismissCallback onDismissed;

  /// Creates an instance of [EasyDismissible]
  const EasyDismissible({
    required this.onDismissed,
  });
}

/// Interface of dismissible
abstract class IEasyDismissor {
  /// Make dialog dismissible
  Widget makeDismissible(Widget dialog);
}
