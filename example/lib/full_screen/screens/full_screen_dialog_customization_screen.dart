// ignore_for_file: unused_element, avoid_print

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

const _content = SizedBox.square(
  dimension: 200.0,
  child: Center(
    child: Text(
      'Custom',
      style: TextStyle(fontSize: 30),
    ),
  ),
);

class FullScreenDialogCustomizationScreen extends StatelessWidget {
  const FullScreenDialogCustomizationScreen({super.key});

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
              onPressed: () {
                _content
                    .fullScreen()
                    .decorate(const _Shell())
                    .animatedTap()
                    .decorate(const _ForegroundAnimation())
                    .decorate(const _BackgroundAnimation())
                    .decorate(
                      EasyDialogDecoration.builder(
                        (_, dialog) => FadeTransition(
                          opacity: dialog.context.animation,
                          child: dialog.content,
                        ),
                      ),
                    )
                    .show();
              },
              child: const Text('Show custom'),
            ),
            ElevatedButton(
              onPressed: () {
                _content
                    .fullScreen(
                      animationConfiguration:
                          const EasyDialogAnimationConfiguration.bounded(
                        reverseDuration: Duration(milliseconds: 50),
                      ),
                    )
                    .decorate(const FullScreenShell.modalBanner())
                    .decorate(const CustomAnimation())
                    .decorate(const _Dismissible())
                    .show();
              },
              child: const Text('fully custom'),
            ),
          ],
        ),
      ),
    );
  }
}

final class _Dismissible extends EasyDialogDismiss<FullScreenDialog> {
  const _Dismissible({super.onDismissed});

  @override
  Widget call(FullScreenDialog dialog) {
    return Dismissible(
      key: UniqueKey(),
      resizeDuration: null,
      confirmDismiss: (direction) async {
        await dialog.context.hideDialog();

        return true;
      },
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        onDismissed?.call();
      },
      child: dialog.content,
    );
  }
}

final class _ForegroundAnimation extends EasyDialogAnimation<FullScreenDialog> {
  const _ForegroundAnimation();

  @override
  Widget call(FullScreenDialog dialog) {
    final animation = dialog.context.animation;
    final rotate = Tween<double>(begin: math.pi, end: math.pi / 360);

    return AnimatedBuilder(
      animation: animation,
      child: dialog.content,
      builder: (_, child) => Transform.scale(
        scale: animation.value,
        child: Transform.rotate(
          angle: animation
              .drive(rotate.chain(CurveTween(curve: Curves.fastOutSlowIn)))
              .value,
          child: dialog.content,
        ),
      ),
    );
  }
}

final class _BackgroundAnimation extends EasyDialogAnimation<FullScreenDialog> {
  const _BackgroundAnimation();

  @override
  Widget call(FullScreenDialog dialog) {
    final animation = dialog.context.animation;

    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) => Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.lerp(
          Colors.transparent,
          Colors.purple.withValues(alpha: 0.6),
          animation.value,
        ),
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: child,
      ),
      child: dialog.content,
    );
  }
}

/// You can provide custom animation
final class CustomAnimation extends EasyDialogAnimation<FullScreenDialog> {
  const CustomAnimation();

  @override
  Widget call(FullScreenDialog dialog) {
    final animation = dialog.context.animation;

    final offset = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    );

    final blur = animation.drive(
      Tween<double>(begin: 0.0, end: 7.0),
    );

    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: animation,
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
          position: animation.drive(
            offset.chain(
              CurveTween(curve: Curves.fastOutSlowIn),
            ),
          ),
          child: Container(
            color: Colors.black.withValues(alpha: 0.3),
            height: double.infinity,
            width: double.infinity,
            child: dialog.content,
          ),
        ),
      ],
    );
  }
}

final class _Shell extends EasyDialogDecoration<FullScreenDialog> {
  const _Shell();

  @override
  Widget call(FullScreenDialog dialog) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.cyanAccent.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: dialog.content,
    );
  }
}
