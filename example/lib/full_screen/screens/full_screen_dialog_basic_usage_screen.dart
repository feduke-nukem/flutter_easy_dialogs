import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

const _foregroundBounce = 'bounce';
const _foregroundFade = 'fade';
const _foregroundExpansion = 'expansion';

const _backgroundFade = 'fade';
const _backgroundBlur = 'blur';

const _dismissibleFullScreenTap = 'tap';

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

const _foregroundAnimators = <String, FullScreenForegroundAnimation>{
  _foregroundBounce: FullScreenForegroundAnimation.bounce(),
  _foregroundFade: FullScreenForegroundAnimation.fade(),
  _foregroundExpansion: FullScreenForegroundAnimation.expansion(),
};

final _backgroundAnimators = <String, FullScreenBackgroundAnimation>{
  _backgroundBlur: FullScreenBackgroundAnimation.blur(
    end: 10.0,
    backgroundColor: Colors.black.withOpacity(0.5),
  ),
  _backgroundFade: FullScreenBackgroundAnimation.fade(
    backgroundColor: Colors.black.withOpacity(0.5),
  ),
};

class FullScreenDialogManagerBasicUsageScreen extends StatefulWidget {
  const FullScreenDialogManagerBasicUsageScreen({Key? key}) : super(key: key);

  @override
  State<FullScreenDialogManagerBasicUsageScreen> createState() =>
      _FullScreenDialogManagerBasicUsageScreenState();
}

class _FullScreenDialogManagerBasicUsageScreenState
    extends State<FullScreenDialogManagerBasicUsageScreen> {
  var _count = 0;
  final _contentAnimationTypeDropDownItems = _foregroundAnimators.entries
      .map(
        (e) => DropdownMenuItem<FullScreenForegroundAnimation>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();
  final _backgroundAnimationTypeDropDownItems = _backgroundAnimators.entries
      .map(
        (e) => DropdownMenuItem<FullScreenBackgroundAnimation>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();
  late final _dismissibles = <String, FullScreenDismiss>{
    _dismissibleFullScreenTap: FullScreenDismiss.tap(
      onDismissed: () => _count++,
    ),
  };
  late final _dismissibleDropDownItems = _dismissibles.entries
      .map(
        (e) => DropdownMenuItem<FullScreenDismiss>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();

  var _selectedForegroundAnimation = _foregroundAnimators.entries.first.value;
  var _selectedBackgroundAnimation = _backgroundAnimators.entries.first.value;
  late var _selectedDismissible = _dismissibles.entries.first.value;

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
                    DropdownButton<FullScreenForegroundAnimation>(
                      items: _contentAnimationTypeDropDownItems,
                      onChanged: (type) => setState(
                        () => _selectedForegroundAnimation = type!,
                      ),
                      value: _selectedForegroundAnimation,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Background animation type'),
                    DropdownButton<FullScreenBackgroundAnimation>(
                      items: _backgroundAnimationTypeDropDownItems,
                      onChanged: (type) => setState(
                        () => _selectedBackgroundAnimation = type!,
                      ),
                      value: _selectedBackgroundAnimation,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Dismissible type'),
                DropdownButton<FullScreenDismiss>(
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
                final messenger = ScaffoldMessenger.of(context);
                final res = await FlutterEasyDialogs.show<int>(
                  EasyDialog.fullScreen(
                    androidWillPop: () async => true,
                    content: _content,
                    decoration: FullScreenDialogShell.modalBanner(
                      boxDecoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.3),
                      ),
                    )
                        .chained(_selectedForegroundAnimation)
                        .chained(_selectedBackgroundAnimation)
                        .chained(_selectedDismissible),
                  ),
                );

                if (res == null) return;
                messenger
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('Result: $res'),
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