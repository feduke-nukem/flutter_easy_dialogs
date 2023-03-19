
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class PositionedDialogCustomizationScreen extends StatelessWidget {
  const PositionedDialogCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Positioned dialog customization'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => FlutterEasyDialogs.controller.showPositioned(
            params: PositionedShowParams(
              animationConfiguration: const EasyAnimationConfiguration(
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
              dismissible: _CustomPositionedDismissible(
                onDismiss: FlutterEasyDialogs.controller.hideAllPositioned,
              ),
            ),
          ),
          child: const Text('show'),
        ),
      ),
    );
  }
}

class _CustomPositionedShell extends StatelessWidget
    implements EasyPositionedDialogShell {
  const _CustomPositionedShell();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.amber,
      // read provided data from context
      child: context.readDialog<EasyPositionedScopeData>().content,
    );
  }
}

class _CustomPositionedAnimator extends EasyPositionedAnimator {
  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    return FadeTransition(
      opacity: parent,
      child: child,
    );
  }
}

class _CustomPositionedDismissible extends EasyPositionedDismissible {
  _CustomPositionedDismissible({required super.onDismiss});

  @override
  Widget makeDismissible(Widget dialog) {
    return ElevatedButton(
      onPressed: super.onDismiss,
      child: dialog,
    );
  }
}
