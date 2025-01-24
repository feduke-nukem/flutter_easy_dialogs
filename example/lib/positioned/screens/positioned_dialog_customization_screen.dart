// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class PositionedDialogManagerCustomizationScreen extends StatelessWidget {
  const PositionedDialogManagerCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Positioned dialog customization'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _show,
              child: const Text('show'),
            ),
          ],
        ),
      ),
    );
  }

  void _show() => EasyDialog.positioned(
        animationConfiguration: const EasyDialogAnimationConfiguration.bounded(
          duration: Duration(milliseconds: 400),
        ),
        position: EasyDialogPosition.bottom,
        decoration: const _CustomPositionedShell()
            .chained(_CustomPositionedAnimation())
            .chained(
              _CustomPositionedDismiss(
                onDismissed: () => 6,
              ),
            ),
        content: const SizedBox.square(
          dimension: 250,
          child: Center(
            child: Text(
              'custom banner',
            ),
          ),
        ),
      ).show().then((value) => print('dismissed with $value'));
}

final class _CustomPositionedShell extends PositionedShell {
  const _CustomPositionedShell();

  @override
  Widget call(PositionedDialog dialog) {
    return SizedBox(
      width: double.infinity,
      height: 200.0,
      child: ColoredBox(
        color: Colors.amber,
        child: dialog.content,
      ),
    );
  }
}

final class _CustomPositionedAnimation
    extends EasyDialogDecoration<PositionedDialog> {
  @override
  Widget call(EasyDialog dialog) {
    final animation = dialog.context.animation;

    final offset = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(animation);
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withValues(
                alpha: animation.value.clamp(0.0, 0.6),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(position: offset, child: dialog.content),
          ),
        ],
      ),
    );
  }
}

final class _CustomPositionedDismiss
    extends EasyDialogDismiss<PositionedDialog> {
  const _CustomPositionedDismiss({
    required super.onDismissed,
  });

  @override
  Widget call(PositionedDialog dialog) {
    return GestureDetector(
      onTap: () => super.handleDismiss(dialog),
      child: dialog.content,
    );
  }
}
