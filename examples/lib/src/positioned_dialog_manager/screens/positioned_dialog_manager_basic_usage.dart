import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:positioned_dialog_manager/positioned_dialog_manager.dart';

const _expansionAnimator = 'expansion';
const _fadeAnimator = 'fade';
const _verticalSlideAnimator = 'verticalSlide';

const _dismissibleGesture = 'gesture';
const _dismissibleNone = 'none';
const _dismissibleHorizontalSwipe = 'swipe';
const _dismissibleTap = 'tap';

const _animators = <String, PositionedAnimator>{
  _expansionAnimator: PositionedAnimator.expansion(),
  _fadeAnimator: PositionedAnimator.fade(),
  _verticalSlideAnimator: PositionedAnimator.verticalSlide(),
};

const _dismissibles = <String, PositionedDismissible>{
  _dismissibleGesture: PositionedDismissible.gesture(),
  _dismissibleNone: PositionedDismissible.none(),
  _dismissibleHorizontalSwipe: PositionedDismissible.swipe(
    direction: PositionedDismissibleSwipeDirection.horizontal,
  ),
  _dismissibleTap: PositionedDismissible.tap(),
};

class PositionedDialogManagerBasicUsageScreen extends StatefulWidget {
  const PositionedDialogManagerBasicUsageScreen({Key? key}) : super(key: key);

  @override
  State<PositionedDialogManagerBasicUsageScreen> createState() =>
      _PositionedDialogManagerBasicUsageScreenState();
}

class _PositionedDialogManagerBasicUsageScreenState
    extends State<PositionedDialogManagerBasicUsageScreen> {
  final _easyDialogManagersProvider = FlutterEasyDialogs.provider;
  final _animatorsDropDownItems = _animators.entries
      .map(
        (e) => DropdownMenuItem<PositionedAnimator>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();
  final _positionDropDownItems = EasyDialogPosition.values
      .map(
        (e) => DropdownMenuItem<EasyDialogPosition>(
          value: e,
          child: Text(e.name),
        ),
      )
      .toList();
  final _dismissibleDropDownItems = _dismissibles.entries
      .map(
        (e) => DropdownMenuItem<PositionedDismissible>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();

  var _selectedAnimator = _animators.values.first;
  var _selectedPosition = EasyDialogPosition.top;
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
                    DropdownButton<PositionedAnimator>(
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
                    DropdownButton<EasyDialogPosition>(
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
                    DropdownButton<PositionedDismissible>(
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
              onPressed: _easyDialogManagersProvider.hideAllPositioned,
              child: const Text('Hide all'),
            ),
            ElevatedButton(
              onPressed: () =>
                  _easyDialogManagersProvider.hidePositioned(_selectedPosition),
              child: const Text('Hide by position'),
            ),
          ],
        ),
      ),
    );
  }

  void _show() {
    _easyDialogManagersProvider.showPositioned(
      PositionedShowParams(
        dismissible: _selectedDismissible,
        animator: _selectedAnimator,
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
  }
}
