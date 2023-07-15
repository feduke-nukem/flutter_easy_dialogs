import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class PositionedDialogFlutterAnimate extends StatefulWidget {
  const PositionedDialogFlutterAnimate({super.key});

  @override
  State<PositionedDialogFlutterAnimate> createState() =>
      _PositionedDialogFlutterAnimateState();
}

class _PositionedDialogFlutterAnimateState
    extends State<PositionedDialogFlutterAnimate>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 1500,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Positioned Dialog Flutter Animate'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FlutterEasyDialogs.show(
              EasyDialog.positioned(
                animationConfiguration:
                    EasyDialogAnimationConfiguration.withController(
                  _controller,
                  willReverse: true,
                ),
                decoration: EasyDialogDecoration.builder(
                  (context, dialog) => dialog.content
                      .animate(controller: _controller)
                      .scale(curve: Curves.fastOutSlowIn)
                      .shake()
                      .elevation()
                      .slide()
                      .fadeIn(),
                ),
                content: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Hello World'),
                      ElevatedButton(
                        onPressed: () {
                          FlutterEasyDialogs.hide(
                            PositionedDialog.identifier(
                              position: EasyDialogPosition.top,
                            ),
                          );
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: const Text('Show Dialog'),
        ),
      ),
    );
  }
}
