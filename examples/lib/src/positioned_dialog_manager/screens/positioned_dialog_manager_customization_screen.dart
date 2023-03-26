import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:positioned_dialog_manager/positioned_dialog_manager.dart';

class PositionedDialogManagerCustomizationScreen extends StatelessWidget {
  const PositionedDialogManagerCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Positioned dialog customization'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => FlutterEasyDialogs.provider.showPositioned(
            PositionedShowParams(
              animationConfiguration: const EasyDialogAnimatorConfiguration(
                duration: Duration(seconds: 1),
                reverseDuration: Duration(milliseconds: 200),
              ),
              shell: const _CustomPositionedShell(),
              content: const SizedBox.square(
                dimension: 250,
                child: Center(
                  child: Text(
                    'custom banner',
                  ),
                ),
              ),
              animator: _CustomPositionedAnimator(),
              dismissible: const _CustomPositionedDismissible(),
            ),
          ),
          child: const Text('show'),
        ),
      ),
    );
  }
}

class _CustomPositionedShell extends PositionedDialogShell {
  const _CustomPositionedShell();

  @override
  Widget decorate(PositionedDialogShellData data) {
    return ColoredBox(
      color: Colors.amber,
      child: data.dialog,
    );
  }
}

class _CustomPositionedAnimator extends PositionedAnimator {
  @override
  Widget decorate(PositionedAnimatorData data) {
    return FadeTransition(
      opacity: data.parent,
      child: data.dialog,
    );
  }
}

class _CustomPositionedDismissible extends PositionedDismissible {
  const _CustomPositionedDismissible() : super(onDismissed: null);

  @override
  Widget decorate(EasyDismissibleData data) {
    return ElevatedButton(
      onPressed: () {
        data.dismissHandler?.call(const EasyDismissiblePayload());
        onDismissed?.call();
      },
      child: data.dialog,
    );
  }
}
