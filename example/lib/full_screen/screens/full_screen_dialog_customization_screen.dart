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
              onPressed: () async {
                await FlutterEasyDialogs.show(
                  FullScreenDialog(
                    content: _content,
                    decoration: const _Shell()
                        .then(const _ForegroundAnimation())
                        .then(const _BackgroundAnimation())
                        .then(
                          EasyDialogDecoration.builder(
                            (_, context) => FadeTransition(
                              opacity: context.animation,
                              child: context.content,
                            ),
                          ),
                        )
                        .then(FullScreenDialog.defaultDismissible),
                  ),
                );
              },
              child: const Text('Show custom'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FlutterEasyDialogs.show(
                  FullScreenDialog(
                    animationConfiguration:
                        const EasyDialogAnimationConfiguration(
                      reverseDuration: Duration(milliseconds: 50),
                    ),
                    content: _content,
                    decoration: FullScreenDialog.defaultShell
                        .then(const CustomAnimator())
                        .then(
                          _Dismissible(
                            onDismissed: () {},
                          ),
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

final class _Dismissible extends EasyDialogDismiss<FullScreenDialog> {
  const _Dismissible({super.onDismissed});

  @override
  Widget call(EasyDialogContext<FullScreenDialog> context) {
    return Dismissible(
      key: UniqueKey(),
      resizeDuration: null,
      confirmDismiss: (direction) async {
        await context.hideDialog();

        return true;
      },
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        onDismissed?.call();
      },
      child: context.content,
    );
  }
}

final class _ForegroundAnimation extends EasyDialogAnimation<FullScreenDialog> {
  const _ForegroundAnimation();

  @override
  Widget call(EasyDialogContext<FullScreenDialog> context) {
    final animation = context.animation;
    final rotate = Tween<double>(begin: math.pi, end: math.pi / 360);

    return AnimatedBuilder(
      animation: animation,
      child: context.content,
      builder: (_, child) => Transform.scale(
        scale: animation.value,
        child: Transform.rotate(
          angle: animation
              .drive(rotate.chain(CurveTween(curve: Curves.fastOutSlowIn)))
              .value,
          child: context.content,
        ),
      ),
    );
  }
}

final class _BackgroundAnimation extends EasyDialogAnimation<FullScreenDialog> {
  const _BackgroundAnimation();

  @override
  Widget call(EasyDialogContext<FullScreenDialog> context) {
    final animation = context.animation;

    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) => Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.lerp(
          Colors.transparent,
          Colors.purple.withOpacity(0.6),
          animation.value,
        ),
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: child,
      ),
      child: context.content,
    );
  }
}

/// You can provide custom animation
final class CustomAnimator extends EasyDialogAnimation<FullScreenDialog> {
  const CustomAnimator();

  @override
  Widget call(EasyDialogContext<FullScreenDialog> context) {
    final animation = context.animation;

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
            color: Colors.black.withOpacity(0.3),
            height: double.infinity,
            width: double.infinity,
            child: context.content,
          ),
        ),
      ],
    );
  }
}

final class _Shell extends EasyDialogDecoration<FullScreenDialog> {
  const _Shell();

  @override
  Widget call(EasyDialogContext<FullScreenDialog> context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.cyanAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.0)),
      child: context.content,
    );
  }
}
