import 'package:flutter/material.dart';

/// Expansion transition
class ExpansionTransition extends AnimatedWidget {
  /// Child
  final Widget child;

  /// Creates an instance of [ExpansionTransition]
  const ExpansionTransition({
    required this.child,
    required Animation<double> expansion,
    super.key,
  }) : super(listenable: expansion);

  @override
  Widget build(BuildContext context) {
    final animation = (super.listenable as Animation<double>);

    return ClipRect(
      child: Align(
        heightFactor: animation.value,
        child: child,
      ),
    );
  }
}
