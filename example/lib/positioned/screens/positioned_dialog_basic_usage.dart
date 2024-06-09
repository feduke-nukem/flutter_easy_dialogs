import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

const _expansionAnimation = 'expansion';
const _fadeAnimation = 'fade';
const _verticalSlideAnimation = 'verticalSlide';

const _dismissibleTap = 'tap';
const _dismissibleHorizontalSwipe = 'swipe';
const _dismissibleVerticalSwipe = 'swipeVertical';
const _dismissibleAnimatedTap = 'animatedTap';

const _animations = <String, EasyDialogAnimation<PositionedDialog>>{
  _expansionAnimation: EasyDialogAnimation.expansion(),
  _fadeAnimation: EasyDialogAnimation.fade(),
  _verticalSlideAnimation: EasyDialogAnimation.slideVertical(),
};

extension on EasyDialogPosition {
  String get name => switch (this) {
        EasyDialogPosition.top => 'top',
        EasyDialogPosition.bottom => 'bottom',
        EasyDialogPosition.center => 'center',
      };
}

class PositionedDialogManagerBasicUsageScreen extends StatefulWidget {
  const PositionedDialogManagerBasicUsageScreen({Key? key}) : super(key: key);

  @override
  State<PositionedDialogManagerBasicUsageScreen> createState() =>
      _PositionedDialogManagerBasicUsageScreenState();
}

class _PositionedDialogManagerBasicUsageScreenState
    extends State<PositionedDialogManagerBasicUsageScreen> {
  var _count = 0;
  late final _dismissibles = <String, EasyDialogDismiss<PositionedDialog>>{
    _dismissibleTap: EasyDialogDismiss.tap(
      onDismissed: () => _count++,
      willDismiss: () => true,
    ),
    _dismissibleHorizontalSwipe: EasyDialogDismiss.swipe(
      onDismissed: () => _count++,
      willDismiss: () => true,
    ),
    _dismissibleVerticalSwipe: EasyDialogDismiss.swipe(
      onDismissed: () => _count++,
      willDismiss: () => true,
      direction: DismissDirection.vertical,
    ),
    _dismissibleAnimatedTap: EasyDialogDismiss.animatedTap(
      onDismissed: () => _count++,
      willDismiss: () => true,
    ),
  };
  final _animatorsDropDownItems = _animations.entries
      .map(
        (e) => DropdownMenuItem<EasyDialogAnimation<PositionedDialog>>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();
  final _positionDropDownItems = <EasyDialogPosition>[
    EasyDialogPosition.top,
    EasyDialogPosition.bottom,
    EasyDialogPosition.center,
  ]
      .map(
        (e) => DropdownMenuItem<EasyDialogPosition>(
          value: e,
          child: Text(e.name),
        ),
      )
      .toList();
  late final _dismissibleDropDownItems = _dismissibles.entries
      .map(
        (e) => DropdownMenuItem<EasyDialogDismiss<PositionedDialog>>(
          value: e.value,
          child: Text(e.key),
        ),
      )
      .toList();

  var _selectedAnimation = _animations.values.first;
  EasyDialogPosition _selectedPosition = EasyDialogPosition.top;
  late var _selectedDismissible = _dismissibles.values.first;
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
                    DropdownButton<EasyDialogAnimation<PositionedDialog>>(
                      items: _animatorsDropDownItems,
                      onChanged: (type) =>
                          setState(() => _selectedAnimation = type!),
                      value: _selectedAnimation,
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
                    DropdownButton<EasyDialogDismiss<PositionedDialog>>(
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5.0,
              ),
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
              onPressed: () =>
                  FlutterEasyDialogs.hideWhere<PositionedDialog>((_) => true),
              child: const Text('Hide all'),
            ),
            ElevatedButton(
              onPressed: () {
                FlutterEasyDialogs.hide(id: EasyDialogPosition.top);
              },
              child: const Text('Hide by position'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _show() async {
    final messenger = ScaffoldMessenger.of(context);

    final content = Container(
      height: 150.0,
      color: Colors.blue[900],
      alignment: Alignment.center,
      child: Text(
        _selectedPosition.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
        ),
      ),
    );

    final result = await content
        .positioned(
          position: _selectedPosition,
          autoHideDuration: _isAutoHide
              ? Duration(milliseconds: _autoHideDuration.toInt())
              : null,
        )
        .decorate(const PositionedShell.banner())
        .decorate(_selectedAnimation)
        .decorate(_selectedDismissible)
        .show();

    if (result == null) return;
    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('Result: $result'),
        ),
      );
  }
}
