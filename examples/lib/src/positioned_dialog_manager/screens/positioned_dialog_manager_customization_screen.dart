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

  void _show() => FlutterEasyDialogs.provider.showPositioned(
        PositionedShowParams(
          animationConfiguration: const EasyDialogAnimatorConfiguration(
            duration: Duration(milliseconds: 400),
          ),
          position: EasyDialogPosition.bottom,
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
      );
}

class _CustomPositionedShell extends PositionedDialogShell {
  const _CustomPositionedShell();

  @override
  Widget decorate(PositionedDialogShellData data) {
    return SizedBox(
      width: double.infinity,
      height: 200.0,
      child: ColoredBox(
        color: Colors.amber,
        child: data.dialog,
      ),
    );
  }
}

class _CustomPositionedAnimator extends PositionedAnimator {
  @override
  Widget decorate(PositionedAnimatorData data) {
    final offset = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(data.parent);

    return AnimatedBuilder(
      animation: data.parent,
      builder: (_, __) => Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withOpacity(
                data.parent.value.clamp(0.0, 0.6),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(position: offset, child: data.dialog),
          ),
        ],
      ),
    );
  }
}

class _CustomPositionedDismissible extends PositionedDismissible {
  const _CustomPositionedDismissible() : super(onDismissed: null);

  @override
  Widget decorate(EasyDismissibleData data) {
    return GestureDetector(
      onTap: () {
        data.dismissHandler?.call(const EasyDismissiblePayload());
        onDismissed?.call();
      },
      child: data.dialog,
    );
  }
}
