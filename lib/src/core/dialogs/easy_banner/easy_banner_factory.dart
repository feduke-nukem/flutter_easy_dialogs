import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/animations/positioned/factory/positioned_animation_factory.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/factory/i_easy_dismissible_factory.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/factory/positioned_dismissible_factory.dart';

/// [EasyBanner] factory
class EasyBannerFactory implements IEasyDialogFactory {
  /// Animation factory
  final IEasyAnimationFactory _animationFactory;

  /// Dismissible factory
  final IEasyDismissibleFactory _dismissibleFactory;

  const EasyBannerFactory({
    required IEasyAnimationFactory animationFactory,
    required IEasyDismissibleFactory dismissibleFactory,
  })  : _animationFactory = animationFactory,
        _dismissibleFactory = dismissibleFactory;

  @override
  Widget createDialog({
    required EasyBannerShowParams params,
  }) {
    final banner = EasyBanner(
      position: params.position,
      padding: params.padding,
      margin: params.margin,
      borderRadius: params.borderRadius,
      backgroundColor: params.backgroundColor,
      child: params.content,
    );

    return banner;
  }

  @override
  IEasyDismissor createDismissible({
    required EasyBannerShowParams params,
    VoidCallback? handleOnDismissed,
  }) {
    final dismissible = _dismissibleFactory.createDismissible(
      PositionedDismissibleCreateParams(
        dismissibleType: params.dismissibleType,
        onDismissed: handleOnDismissed != null
            ? () {
                params.onDismissed?.call();
                handleOnDismissed();
              }
            : params.onDismissed!,
      ),
    );

    return dismissible;
  }

  @override
  IEasyAnimator createAnimation({
    required EasyBannerShowParams params,
  }) {
    if (params.customAnimation != null) return params.customAnimation!;

    final animation = _animationFactory.createAnimation(
      params: PositionedAnimationCreateParams(
        curve: params.animationSettings?.curve ??
            params.theme.easyBannerTheme.animationCurve,
        position: params.position,
        animationType: params.animationType,
      ),
    );

    return animation;
  }
}
