import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class PositionedDialogsScreen extends StatefulWidget {
  const PositionedDialogsScreen({Key? key}) : super(key: key);

  @override
  State<PositionedDialogsScreen> createState() =>
      _PositionedDialogsScreenState();
}

class _PositionedDialogsScreenState extends State<PositionedDialogsScreen> {
  final _easyDialogsController = FlutterEasyDialogs.dialogsController;
  final _animationTypeDropDownItems = EasyPositionedAnimationType.values
      .map(
        (e) => DropdownMenuItem<EasyPositionedAnimationType>(
          value: e,
          child: Text(e.name),
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
  final _dismissibleDropDownItems = EasyPositionedDismissibleType.values
      .map(
        (e) => DropdownMenuItem<EasyPositionedDismissibleType>(
          value: e,
          child: Text(e.name),
        ),
      )
      .toList();

  var _selectedAnimationType = EasyPositionedAnimationType.fade;
  var _selectedPosition = EasyDialogPosition.top;
  var _selectedDismissibleType = EasyPositionedDismissibleType.swipe;
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
                    DropdownButton<EasyPositionedAnimationType>(
                      items: _animationTypeDropDownItems,
                      onChanged: (type) =>
                          setState(() => _selectedAnimationType = type!),
                      value: _selectedAnimationType,
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
                    DropdownButton<EasyPositionedDismissibleType>(
                      items: _dismissibleDropDownItems,
                      onChanged: (type) =>
                          setState(() => _selectedDismissibleType = type!),
                      value: _selectedDismissibleType,
                    ),
                  ],
                ),
              ],
            ),
            CheckboxListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              title: const Text('Autohide'),
              value: _isAutoHide,
              onChanged: (value) => setState(() => _isAutoHide = value!),
            ),
            if (_isAutoHide) ...[
              const Text('Autohide duration in milliseconds'),
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
              onPressed: _easyDialogsController.hideAllBanners,
              child: const Text('Hide all'),
            ),
            ElevatedButton(
              onPressed: () => _easyDialogsController.hideBanner(
                position: _selectedPosition,
              ),
              child: const Text('Hide by position'),
            ),
          ],
        ),
      ),
    );
  }

  void _show() {
    _easyDialogsController.showBanner(
      onDismissed: () {},
      content: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.red),
        onPressed: () {},
        child: const Text(
          'BANNER',
          style: TextStyle(fontSize: 30),
        ),
      ),
      durationUntilHide: Duration(milliseconds: _autoHideDuration.toInt()),
      autoHide: _isAutoHide,
      position: _selectedPosition,
      animationType: _selectedAnimationType,
      dismissibleType: _selectedDismissibleType,
    );
  }
}
