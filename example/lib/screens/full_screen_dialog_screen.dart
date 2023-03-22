import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

final _content = Container(
  height: 200.0,
  width: 200.0,
  color: Colors.red,
  child: const Icon(
    Icons.home,
    size: 60,
  ),
);

class FullScreenDialogScreen extends StatefulWidget {
  const FullScreenDialogScreen({Key? key}) : super(key: key);

  @override
  State<FullScreenDialogScreen> createState() => _FullScreenDialogScreenState();
}

class _FullScreenDialogScreenState extends State<FullScreenDialogScreen> {
  final _easyDialogsController = FlutterEasyDialogs.controller;

  final _contentAnimationTypeDropDownItems =
      EasyFullScreenContentAnimationType.values
          .map(
            (e) => DropdownMenuItem<EasyFullScreenContentAnimationType>(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList();
  final _backgroundAnimationTypeDropDownItems =
      EasyFullScreenBackgroundAnimationType.values
          .map(
            (e) => DropdownMenuItem<EasyFullScreenBackgroundAnimationType>(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList();

  var _selectedContentAnimationType = EasyFullScreenContentAnimationType.bounce;
  var _selectedBackgroundAnimationType =
      EasyFullScreenBackgroundAnimationType.blur;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Dialogs Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Content animation type'),
                    DropdownButton<EasyFullScreenContentAnimationType>(
                      items: _contentAnimationTypeDropDownItems,
                      onChanged: (type) => setState(
                        () => _selectedContentAnimationType = type!,
                      ),
                      value: _selectedContentAnimationType,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Background animation type'),
                    DropdownButton<EasyFullScreenBackgroundAnimationType>(
                      items: _backgroundAnimationTypeDropDownItems,
                      onChanged: (type) => setState(
                        () => _selectedBackgroundAnimationType = type!,
                      ),
                      value: _selectedBackgroundAnimationType,
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await _easyDialogsController.showFullScreen(
                  params: FullScreenShowParams(
                    content: _content,
                    foregroundAnimator:
                        EasyFullScreenForegroundAnimator.fromType(
                      type: _selectedContentAnimationType,
                    ),
                    backgroundAnimator:
                        EasyFullScreenBackgroundAnimator.fromType(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      type: _selectedBackgroundAnimationType,
                    ),
                    shell: EasyFullScreenDialogShell.modalBanner(
                      boxDecoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.3),
                      ),
                    ),
                    dismissible: EasyFullScreenDismissible.gesture(
                      onDismiss: _easyDialogsController.hideFullScreen,
                    ),
                  ),
                );
              },
              child: const Text('Show'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _easyDialogsController.showFullScreen(
                  params: FullScreenShowParams(
                    customAnimator: CustomAnimator(),
                    content: _content,
                    foregroundAnimator:
                        EasyFullScreenForegroundAnimator.fromType(
                      type: _selectedContentAnimationType,
                    ),
                    backgroundAnimator:
                        EasyFullScreenBackgroundAnimator.fromType(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      type: _selectedBackgroundAnimationType,
                    ),
                    shell: EasyFullScreenDialogShell.modalBanner(
                      boxDecoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.3),
                      ),
                    ),
                    dismissible: EasyFullScreenDismissible.gesture(
                      onDismiss: _easyDialogsController.hideFullScreen,
                    ),
                  ),
                );
              },
              child: const Text('Show custom background animation'),
            )
          ],
        ),
      ),
    );
  }
}

/// You can provide custom animation
class CustomAnimator implements IEasyDialogAnimator {
  @override
  Widget animate({required Animation<double> parent, required Widget child}) {
    final offset = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    );

    return SlideTransition(
      position: offset.animate(parent),
      child: Container(
        color: Colors.black.withOpacity(0.3),
        height: double.infinity,
        width: double.infinity,
        child: child,
      ),
    );
  }
}
