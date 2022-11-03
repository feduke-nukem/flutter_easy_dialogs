import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/core/agents/fullscreen_dialog_agent/fullscreen_dialog_hide_params.dart';
import 'package:flutter_easy_dialogs/src/core/agents/fullscreen_dialog_agent/fullscreen_dialog_show_params.dart';

const _position = EasyDialogPosition.center;

class FullScreenDialogAgent extends EasyDialogAgentBase {
  FullScreenDialogAgent({
    required super.overlayController,
    required super.dialogFactory,
  });

  AnimationController? _animationController;

  bool get _isPresented => _animationController != null;

  @override
  Future<void> hide({FullScreenHideParams? params}) async {
    await _hide();
  }

  @override
  Future<void> show({required FullScreenShowParams params}) async {
    if (_isPresented) await _hide();

    BackButtonInterceptor.add(_backButtonInterceptor);

    _animationController = AnimationController(
      vsync: super.overlayController,
      duration: params.contentAnimationType ==
              EasyFullScreenContentAnimationType.bounce
          ? const Duration(milliseconds: 180)
          : const Duration(milliseconds: 300),
    );

    final dialog = _createDialog(params);

    super.overlayController.insertDialog(
          child: dialog,
          position: _position,
          type: super.dialogFactory.dialogType,
        );

    await _animationController!.forward();
  }

  Widget _createDialog(FullScreenShowParams params) {
    final modalBanner = super.dialogFactory.createDialog(params: params);

    final animation = super.dialogFactory.createAnimation(params: params);

    assert(
      _animationController != null,
      '$_animationController must be assigned',
    );

    final animatedModalBanner = animation.animate(
      parent: _animationController!,
      child: modalBanner,
    );

    if (params.onDismissed == null) return animatedModalBanner;

    return dialogFactory
        .createDismissible(params: params)
        .makeDismissible(animatedModalBanner);
  }

  Future<void> _hide() async {
    if (!_isPresented) return;

    await _animationController!.reverse();
    _animationController!.dispose();
    _animationController = null;

    super.overlayController.removeDialogByTypeAndPosition(
          type: super.dialogFactory.dialogType,
          position: _position,
        );

    BackButtonInterceptor.remove(_backButtonInterceptor);
  }

  bool _backButtonInterceptor(
    bool stopDefaultButtonEvent,
    RouteInfo routeInfo,
  ) =>
      true;
}
