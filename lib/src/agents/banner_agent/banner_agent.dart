import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/agents/banner_agent/banner_dismiss_params.dart';
import 'package:flutter_easy_dialogs/src/agents/banner_agent/banner_show_params.dart';
import 'package:flutter_easy_dialogs/src/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/utils/position_to_animation_converter.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_banner.dart';

class BannerAgent extends DialogAgentBase {
  final IPositionToAnimationConverter _positionToAnimationConverter;
  final _currentBanners = <EasyDialogPosition, AnimationController>{};

  @override
  Future<void> hide({
    required BannerDismissParams params,
  }) async {
    if (params.dismissAll) {
      for (final entry in _currentBanners.entries) {
        await _hide(
          position: entry.key,
          animationController: entry.value,
          removeFromCurrentBanners: false,
        );
      }
      _currentBanners.clear();

      return;
    }

    final animationController =
        _getAnimationControllerOfPosition(params.position);

    if (animationController == null) return;

    await _hide(
      position: params.position,
      animationController: animationController,
    );
  }

  BannerAgent({
    required IPositionToAnimationConverter positionToAnimationConverter,
    required super.overlayController,
  }) : _positionToAnimationConverter = positionToAnimationConverter;

  @override
  Future<void> show({
    required BannerShowParams params,
  }) async {
    final existingDialogAnimationController = _getAnimationControllerOfPosition(
      params.position,
    );

    if (existingDialogAnimationController != null) {
      await _hide(
        position: params.position,
        animationController: existingDialogAnimationController,
      );
    }

    final newAnimationController = _createAnimationController(params: params);

    final dialog = _createDialog(
      animationController: newAnimationController,
      params: params,
    );

    super.overlayController.insertDialog(
          child: dialog,
          position: params.position,
          type: EasyDialogType.banner,
        );

    _addAnimationControllerOfPosition(
      params.position,
      newAnimationController,
    );

    await newAnimationController.forward();

    if (!params.autoHide) return;

    await Future.delayed(params.theme.easyBannerTheme.durationUntilAutoHide);

    final animationControllerOfPosition =
        _getAnimationControllerOfPosition(params.position);

    final shouldHide = identical(
      newAnimationController,
      animationControllerOfPosition,
    );

    if (!shouldHide) return;

    await _hide(
      position: params.position,
      animationController: newAnimationController,
    );
  }

  IEasyDialogsAnimator _createAnimator({
    required BannerShowParams params,
    required AnimationController animationController,
  }) {
    final animation = _positionToAnimationConverter.convert(
      curve: params.animationSettings?.curve ??
          params.theme.easyBannerTheme.animationCurve,
      animationType: params.animationType,
      position: params.position,
    );

    return animation;
  }

  Widget _createDialog({
    required BannerShowParams params,
    required AnimationController animationController,
  }) {
    final animator = _createAnimator(
      params: params,
      animationController: animationController,
    );

    final banner = _createBanner(params: params);

    final dialog = animator.animate(
      parent: animationController,
      child: banner,
    );

    return dialog;
  }

  Widget _createBanner({
    required BannerShowParams params,
  }) {
    final banner = EasyBanner(
      topSafeArea: params.position == EasyDialogPosition.top,
      bottomSafeArea: params.position == EasyDialogPosition.bottom,
      padding: params.padding,
      child: params.content,
    );

    return banner;
  }

  AnimationController _createAnimationController({
    required BannerShowParams params,
  }) {
    return AnimationController(
      vsync: super.overlayController,
      duration: params.animationSettings?.duration ??
          params.theme.easyBannerTheme.forwardDuration,
      reverseDuration: params.animationSettings?.reverseDuration ??
          params.theme.easyBannerTheme.reverseDuration,
    );
  }

  Future<void> _hide({
    required EasyDialogPosition position,
    required AnimationController animationController,
    bool removeFromCurrentBanners = true,
  }) async {
    await animationController.reverse();
    animationController.dispose();

    overlayController.removeDialogByTypeAndPosition(
      type: EasyDialogType.banner,
      position: position,
    );

    if (removeFromCurrentBanners) _currentBanners.remove(position);
  }

  AnimationController? _getAnimationControllerOfPosition(
    EasyDialogPosition position,
  ) =>
      _currentBanners[position];

  void _addAnimationControllerOfPosition(
    EasyDialogPosition position,
    AnimationController controller,
  ) =>
      _currentBanners[position] = controller;
}
