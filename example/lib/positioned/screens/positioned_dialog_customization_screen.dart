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

  void _show() => FlutterEasyDialogs.show(
        PositionedDialog(
          animationConfiguration: const EasyDialogAnimationConfiguration(
            duration: Duration(milliseconds: 400),
          ),
          position: EasyDialogPosition.bottom,
          decoration: const _CustomPositionedShell()
              .then(_CustomPositionedAnimator())
              .then(const _CustomPositionedDismissible()),
          content: const SizedBox.square(
            dimension: 250,
            child: Center(
              child: Text(
                'custom banner',
              ),
            ),
          ),
        ),
      );
}

final class _CustomPositionedShell extends PositionedDialogShell {
  const _CustomPositionedShell();

  @override
  Widget call(PositionedDialog dialog, Widget content) {
    return SizedBox(
      width: double.infinity,
      height: 200.0,
      child: ColoredBox(
        color: Colors.amber,
        child: content,
      ),
    );
  }
}

final class _CustomPositionedAnimator extends PositionedAnimation {
  @override
  Widget call(PositionedDialog dialog, Widget content) {
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
              color: Colors.black.withOpacity(
                animation.value.clamp(0.0, 0.6),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(position: offset, child: content),
          ),
        ],
      ),
    );
  }
}

final class _CustomPositionedDismissible extends PositionedDismiss {
  const _CustomPositionedDismissible() : super(onDismissed: null);

  @override
  Widget call(PositionedDialog dialog, Widget content) {
    return GestureDetector(
      onTap: () {
        dialog.context.hide();
        onDismissed?.call();
      },
      child: content,
    );
  }
}
