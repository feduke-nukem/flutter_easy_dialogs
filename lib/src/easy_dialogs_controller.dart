// ignore_for_file: no-magic-number

import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/full_screen/manager/full_screen_dialog_manager.dart';

import 'positioned/manager/positioned_dialog_manager.dart';

/// Implementation of [IEasyDialogsController].
class EasyDialogsController implements IEasyDialogsController {
  final IEasyOverlayController _overlayController;
  late final _positionedManager =
      PositionedDialogManager(overlayController: _overlayController);
  late final _fullScreenManager =
      FullScreenDialogManager(overlayController: _overlayController);
  final Map<Type, EasyDialogManager> _customManagers;

  /// Creates an instance of [EasyDialogsController].
  EasyDialogsController({
    required IEasyOverlayController overlayController,
    required Map<Type, EasyDialogManager> customManagers,
  })  : _overlayController = overlayController,
        _customManagers = customManagers;

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyDialogsController &&
        _positionedManager == other._positionedManager &&
        _fullScreenManager == other._fullScreenManager &&
        _customManagers == other._customManagers;
  }

  @override
  int get hashCode {
    final values = [
      _positionedManager,
      _fullScreenManager,
      _customManagers,
    ];

    return Object.hashAll(values);
  }

  @override
  Future<void> showPositioned({
    required PositionedShowParams params,
  }) {
    return _positionedManager.show(
      params: params,
    );
  }

  @override
  Future<void> hidePositioned({
    required EasyDialogPosition position,
  }) async {
    await _positionedManager.hide(
      params: PositionedHideParams(
        position: position,
      ),
    );
  }

  @override
  Future<void> hideAllPositioned() async {
    await _positionedManager.hide(
      params: PositionedHideParams(
        hideAll: true,
      ),
    );
  }

  @override
  Future<void> showFullScreen({
    required FullScreenShowParams params,
  }) =>
      _fullScreenManager.show(params: params);

  @override
  Future<void> hideFullScreen() => _fullScreenManager.hide();

  @override
  T useCustom<T extends CustomDialogManager>() {
    assert(
      _customManagers.containsKey(T),
      'You should register agent named $T before calling it',
    );

    return _customManagers[T]! as T;
  }
}
