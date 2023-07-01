import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

const _result = 'dialog result';

const _expansionAnimator = 'expansion';
const _fadeAnimator = 'fade';
const _verticalSlideAnimator = 'verticalSlide';

const _dismissibleTap = 'tap';
const _dismissibleHorizontalSwipe = 'swipe';
const _dismissibleVerticalSwipe = 'swipeVertical';
const _dismissibleAnimatedTap = 'animatedTap';

const _animators = <String, PositionedAnimation>{
  _expansionAnimator: PositionedAnimation.expansion(),
  _fadeAnimator: PositionedAnimation.fade(),
  _verticalSlideAnimator: PositionedAnimation.verticalSlide(),
};

final _dismissibles = <String, PositionedDismiss>{
  _dismissibleTap: PositionedDismiss.tap(
    onDismissed: () => _result,
    willDismiss: () async => true,
  ),
  _dismissibleHorizontalSwipe: PositionedDismiss.swipe(
    onDismissed: () => _result,
    willDismiss: () async => false,
  ),
  _dismissibleVerticalSwipe: PositionedDismiss.swipe(
    onDismissed: () => _result,
    willDismiss: () async => false,
    direction: PositionedDismissibleSwipeDirection.vertical,
  ),
  _dismissibleAnimatedTap: PositionedDismiss.animatedTap(
    onDismissed: () => _result,
    willDismiss: () async => true,
  ),
};

class PositionedDialogManagerBasicUsageScreen extends StatefulWidget {
  const PositionedDialogManagerBasicUsageScreen({Key? key}) : super(key: key);

  @override
  State<PositionedDialogManagerBasicUsageScreen> createState() =>
      _PositionedDialogManagerBasicUsageScreenState();
}

class _PositionedDialogManagerBasicUsageScreenState
    extends State<PositionedDialogManagerBasicUsageScreen> {
  final _animatorsDropDownItems = _animators.entries
      .map(
        (e) => DropdownMenuItem<PositionedAnimation>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();
  final _positionDropDownItems = <EasyDialogShowPosition>[
    EasyDialogPosition.top,
    EasyDialogPosition.bottom,
    EasyDialogPosition.center,
  ]
      .map(
        (e) => DropdownMenuItem<EasyDialogShowPosition>(
          value: e,
          child: Text(e.name),
        ),
      )
      .toList();
  final _dismissibleDropDownItems = _dismissibles.entries
      .map(
        (e) => DropdownMenuItem<PositionedDismiss>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();

  var _selectedAnimator = _animators.values.first;
  EasyDialogShowPosition _selectedPosition = EasyDialogPosition.top;
  var _selectedDismissible = _dismissibles.values.first;
  var _isAutoHide = false;
  var _autoHideDuration = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Positioned dialogs'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Animation type'),
                    DropdownButton<PositionedAnimation>(
                      items: _animatorsDropDownItems,
                      onChanged: (type) =>
                          setState(() => _selectedAnimator = type!),
                      value: _selectedAnimator,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Position'),
                    DropdownButton<EasyDialogShowPosition>(
                      items: _positionDropDownItems,
                      onChanged: (position) =>
                          setState(() => _selectedPosition = position!),
                      value: _selectedPosition,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Dismissible type'),
                    DropdownButton<PositionedDismiss>(
                      items: _dismissibleDropDownItems,
                      onChanged: (type) =>
                          setState(() => _selectedDismissible = type!),
                      value: _selectedDismissible,
                    ),
                  ],
                ),
              ],
            ),
            CheckboxListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              title: const Text('Auto hide'),
              value: _isAutoHide,
              onChanged: (value) => setState(() => _isAutoHide = value!),
            ),
            if (_isAutoHide) ...[
              const Text('Auto hide duration in milliseconds'),
              Slider(
                max: 2000,
                value: _autoHideDuration,
                onChanged: (value) => setState(() => _autoHideDuration = value),
              ),
            ],
            ElevatedButton(
              onPressed: _show,
              child: const Text('Show'),
            ),
            ElevatedButton(
              onPressed: () => FlutterEasyDialogs.hide(
                PositionedDialog.createHiding(
                  position: EasyDialogPosition.all,
                ),
              ),
              child: const Text('Hide all'),
            ),
            ElevatedButton(
              onPressed: () => FlutterEasyDialogs.hide(
                PositionedDialog.createHiding(position: _selectedPosition),
              ),
              child: const Text('Hide by position'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _show() async {
    final result = await FlutterEasyDialogs.show<String>(
      PositionedDialog(
        decoration: PositionedDialog.defaultShell
            .then(_selectedAnimator)
            .then(_selectedDismissible),
        hideAfterDuration: _isAutoHide
            ? Duration(milliseconds: _autoHideDuration.toInt())
            : null,
        content: Container(
          height: 150.0,
          color: Colors.amber[900],
          alignment: Alignment.center,
          child: Text('$_selectedPosition'),
        ),
        position: _selectedPosition,
      ),
    );

    if (result == null) return;

    print('reslut: $result');
  }
}
