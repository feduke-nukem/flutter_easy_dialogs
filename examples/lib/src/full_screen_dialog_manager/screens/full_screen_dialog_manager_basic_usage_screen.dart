import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:full_screen_dialog_manager/full_screen_dialog_manager.dart';

const _foregroundBounce = 'bounce';
const _foregroundFade = 'fade';
const _foregroundExpansion = 'expansion';
const _foregroundNone = 'none';

const _backgroundFade = 'fade';
const _backgroundBlur = 'blur';
const _backgroundNone = 'none';

const _dismissibleGesture = 'gesture';
const _dismissibleNone = 'none';

const _content = SizedBox.square(
  dimension: 200.0,
  child: Center(
    child: SizedBox.square(
      dimension: 150,
      child: CircularProgressIndicator(
        strokeWidth: 10.0,
      ),
    ),
  ),
);

const _foregroundAnimators = <String, FullScreenForegroundAnimator>{
  _foregroundBounce: FullScreenForegroundAnimator.bounce(),
  _foregroundFade: FullScreenForegroundAnimator.fade(),
  _foregroundExpansion: FullScreenForegroundAnimator.expansion(),
  _foregroundNone: FullScreenForegroundAnimator.none(),
};

final _backgroundAnimators = <String, FullScreenBackgroundAnimator>{
  _backgroundBlur: FullScreenBackgroundAnimator.blur(
    start: 0.0,
    end: 10.0,
    backgroundColor: Colors.black.withOpacity(0.5),
  ),
  _backgroundFade: FullScreenBackgroundAnimator.fade(
    backgroundColor: Colors.black.withOpacity(0.5),
  ),
  _backgroundNone: const FullScreenBackgroundAnimator.none(),
};

const _dismissibles = <String, FullScreenDismissible>{
  _dismissibleGesture: FullScreenDismissible.gesture(),
  _dismissibleNone: FullScreenDismissible.none(),
};

class FullScreenDialogManagerBasicUsageScreen extends StatefulWidget {
  const FullScreenDialogManagerBasicUsageScreen({Key? key}) : super(key: key);

  @override
  State<FullScreenDialogManagerBasicUsageScreen> createState() =>
      _FullScreenDialogManagerBasicUsageScreenState();
}

class _FullScreenDialogManagerBasicUsageScreenState
    extends State<FullScreenDialogManagerBasicUsageScreen> {
  final _easyDialogsController = FlutterEasyDialogs.controller;

  final _contentAnimationTypeDropDownItems = _foregroundAnimators.entries
      .map(
        (e) => DropdownMenuItem<FullScreenForegroundAnimator>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();
  final _backgroundAnimationTypeDropDownItems = _backgroundAnimators.entries
      .map(
        (e) => DropdownMenuItem<FullScreenBackgroundAnimator>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();

  final _dismissibleDropDownItems = _dismissibles.entries
      .map(
        (e) => DropdownMenuItem<FullScreenDismissible>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();

  var _selectedForegroundAnimator = _foregroundAnimators.entries.first.value;
  var _selectedBackgroundAnimator = _backgroundAnimators.entries.first.value;
  var _selectedDismissible = _dismissibles.entries.first.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic usage example'),
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
                    DropdownButton<FullScreenForegroundAnimator>(
                      items: _contentAnimationTypeDropDownItems,
                      onChanged: (type) => setState(
                        () => _selectedForegroundAnimator = type!,
                      ),
                      value: _selectedForegroundAnimator,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Background animation type'),
                    DropdownButton<FullScreenBackgroundAnimator>(
                      items: _backgroundAnimationTypeDropDownItems,
                      onChanged: (type) => setState(
                        () => _selectedBackgroundAnimator = type!,
                      ),
                      value: _selectedBackgroundAnimator,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Dismissible type'),
                DropdownButton<FullScreenDismissible>(
                  items: _dismissibleDropDownItems,
                  onChanged: (type) => setState(
                    () => _selectedDismissible = type!,
                  ),
                  value: _selectedDismissible,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await _easyDialogsController.showFullScreen(
                  FullScreenShowParams(
                    content: _content,
                    foregroundAnimator: _selectedForegroundAnimator,
                    backgroundAnimator: _selectedBackgroundAnimator,
                    shell: FullScreenDialogShell.modalBanner(
                      boxDecoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.3),
                      ),
                    ),
                    dismissible: _selectedDismissible,
                  ),
                );
              },
              child: const Text('Show'),
            ),
          ],
        ),
      ),
    );
  }
}
