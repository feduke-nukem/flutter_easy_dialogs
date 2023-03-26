import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';

const _content = SizedBox.square(
  dimension: 200.0,
  child: Center(
    child: Text(
      'Custom',
      style: TextStyle(fontSize: 30),
    ),
  ),
);

class FullScreenDialogManagerCustomizationScreen extends StatelessWidget {
  const FullScreenDialogManagerCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customization'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await FlutterEasyDialogs.controller.showFullScreen(
                  const FullScreenShowParams(
                    content: _content,
                    foregroundAnimator: _ForegroundAnimator(),
                    backgroundAnimator: _BackgroundAnimator(),
                    shell: _Shell(),
                  ),
                );
              },
              child: const Text('Show custom'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FlutterEasyDialogs.controller.showFullScreen(
                  FullScreenShowParams(
                    animationConfiguration:
                        const EasyDialogAnimatorConfiguration(
                      reverseDuration: Duration(milliseconds: 50),
                    ),
                    content: _content,
                    customAnimator: const CustomAnimator(),
                    shell: const FullScreenDialogShell.modalBanner(),
                    dismissible: _Dismissible(
                      onDismissed: () {},
                    ),
                  ),
                );
              },
              child: const Text('fully custom'),
            )
          ],
        ),
      ),
    );
  }
}

class _Dismissible extends FullScreenDismissible {
  const _Dismissible({super.onDismissed});

  @override
  Widget decorate(EasyDismissibleData data) {
    return Dismissible(
      key: UniqueKey(),
      resizeDuration: null,
      confirmDismiss: (direction) async {
        await data.dismissHandler?.call(
          const EasyDismissiblePayload(),
        );

        return true;
      },
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        onDismissed?.call();
      },
      child: data.dialog,
    );
  }
}

class _ForegroundAnimator extends FullScreenForegroundAnimator {
  const _ForegroundAnimator();

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    final rotate = Tween<double>(begin: math.pi, end: math.pi / 360);

    return AnimatedBuilder(
      animation: data.parent,
      builder: (context, child) => Transform.scale(
        scale: data.parent.value,
        child: Opacity(
          opacity: data.parent.value,
          child: Transform.rotate(
            angle: data.parent
                .drive(rotate.chain(CurveTween(curve: Curves.fastOutSlowIn)))
                .value,
            child: child,
          ),
        ),
      ),
      child: data.dialog,
    );
  }
}

class _BackgroundAnimator extends FullScreenBackgroundAnimator {
  const _BackgroundAnimator();

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    return AnimatedBuilder(
      animation: data.parent,
      builder: (_, child) => Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.lerp(Colors.transparent, Colors.purple.withOpacity(0.6),
            data.parent.value),
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: child,
      ),
      child: data.dialog,
    );
  }
}

/// You can provide custom animation
class CustomAnimator extends EasyDialogAnimator {
  const CustomAnimator();

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    final offset = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    );

    final blur = data.parent.drive(
      Tween<double>(begin: 0.0, end: 7.0),
    );

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: data.parent,
            builder: (_, __) => BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blur.value,
                sigmaY: blur.value,
              ),
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
        ),
        SlideTransition(
          position: data.parent.drive(
            offset.chain(
              CurveTween(curve: Curves.fastOutSlowIn),
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            height: double.infinity,
            width: double.infinity,
            child: data.dialog,
          ),
        ),
      ],
    );
  }
}

class _Shell extends FullScreenDialogShell {
  const _Shell();

  @override
  Widget decorate(EasyDialogDecoratorData data) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.cyanAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.0)),
      child: data.dialog,
    );
  }
}
