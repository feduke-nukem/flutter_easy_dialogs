import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/agents/full_screen_dialog_agent/full_screen_dialog_hide_params.dart';
import 'package:flutter_easy_dialogs/src/core/agents/full_screen_dialog_agent/full_screen_dialog_show_params.dart';

/// ### Agent for displaying fullscreen dialogs
/// Only one fullscreen dialog can be presented at the same time
class FullScreenDialogAgent
    extends EasyDialogAgentBase<FullScreenShowParams, FullScreenHideParams> {
  /// factory
  final IEasyDialogFactory _dialogFactory;

  /// Creates an instance of [FullScreenDialogAgent]
  FullScreenDialogAgent({
    required super.overlayController,
    required IEasyDialogFactory dialogFactory,
  }) : _dialogFactory = dialogFactory;

  /// [AnimationController] for providing animations to the dialogs,
  /// is null, when the dialog is not presented
  AnimationController? _animationController;

  bool get _isPresented => _animationController != null;

  @override
  Future<void> hide({FullScreenHideParams? params}) async {
    await _hide();
  }

  @override
  Future<void> show({required FullScreenShowParams params}) async {
    if (_isPresented) await _hide();

    // For disabling back button on Android
    BackButtonInterceptor.add(_backButtonInterceptor);

    _animationController = AnimationController(
      vsync: super.overlayController,
      duration: params.contentAnimationType ==
              EasyFullScreenContentAnimationType.bounce
          ? const Duration(milliseconds: 180)
          : const Duration(milliseconds: 300),
    );

    final dialog = _createDialog(params);

    super.overlayController.insertFullScreenDialog(dialog: dialog);

    await _animationController!.forward();
  }

  Widget _createDialog(FullScreenShowParams params) {
    final modalBanner = _dialogFactory.createDialog(params: params);

    final animation = _dialogFactory.createAnimation(params: params);

    assert(
      _animationController != null,
      '$_animationController must be assigned',
    );

    final animatedModalBanner = animation.animate(
      parent: _animationController!,
      child: modalBanner,
    );

    if (params.onDismissed == null) return animatedModalBanner;

    return _dialogFactory
        .createDismissible(params: params)
        .makeDismissible(animatedModalBanner);
  }

  Future<void> _hide() async {
    if (!_isPresented) return;

    await _animationController!.reverse();
    _animationController!.dispose();
    _animationController = null;

    super.overlayController.removeFullScreenDialog();

    BackButtonInterceptor.remove(_backButtonInterceptor);
  }

  bool _backButtonInterceptor(
    bool stopDefaultButtonEvent,
    RouteInfo routeInfo,
  ) =>
      true;
}
