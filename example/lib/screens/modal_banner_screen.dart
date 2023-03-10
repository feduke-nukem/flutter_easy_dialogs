import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class ModalBannerScreen extends StatefulWidget {
  const ModalBannerScreen({Key? key}) : super(key: key);

  @override
  State<ModalBannerScreen> createState() => _ModalBannerScreenState();
}

class _ModalBannerScreenState extends State<ModalBannerScreen> {
  final _easyDialogsController = FlutterEasyDialogs.dialogsController;

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
                    const Text('Backgroung animation type'),
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
                await _easyDialogsController.showModalBanner(
                  contentAnimationType: _selectedContentAnimationType,
                  onDismissed: _easyDialogsController.hideModalBanner,
                  backgroundAnimationType: _selectedBackgroundAnimationType,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  content: Container(
                    height: 200.0,
                    width: 200.0,
                    color: Colors.red,
                    child: const Icon(
                      Icons.home,
                      size: 60,
                    ),
                  ),
                );
              },
              child: const Text('Show'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _easyDialogsController.showModalBanner(
                  contentAnimationType: _selectedContentAnimationType,
                  onDismissed: _easyDialogsController.hideModalBanner,
                  backgroundAnimationType: _selectedBackgroundAnimationType,
                  customBackgroundAnimation: CustomAnimator(),
                  backgroundColor: Colors.black,
                  content: Container(
                    height: 200.0,
                    width: 200.0,
                    color: Colors.red,
                    child: const Icon(
                      Icons.home,
                      size: 60,
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
class CustomAnimator implements IEasyAnimator {
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
