import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/agents/banner/banner_show_params.dart';
import 'package:flutter_easy_dialogs/src/core/animations/factory/positioned_animation_factory/positioned_animation_create_params.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/factory/i_easy_dismissible_factory.dart';

class EasyBannerFactory implements IEasyDialogFactory {
  @override
  final dialogType = EasyDialogType.banner;

  final IEasyAnimationFactory _animationFactory;
  final IEasyDismissibleFactory _dismissibleFactory;

  const EasyBannerFactory({
    required IEasyAnimationFactory animationFactory,
    required IEasyDismissibleFactory dismissibleFactory,
  })  : _animationFactory = animationFactory,
        _dismissibleFactory = dismissibleFactory;

  @override
  Widget createDialog({
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

  @override
  IEasyDismissor createDismissible({
    required BannerShowParams params,
    VoidCallback? handleOnDismissed,
  }) {
    if (params.dismissibleType != EasyDismissibleType.none) {
      assert(
        params.onDismissed != null,
        '${params.onDismissed} must be provided',
      );
    }

    final dismissible = _dismissibleFactory.createDismissible(
      DismissibleCreateParams(
        dismissibleType: params.dismissibleType,
        onDismissed: handleOnDismissed != null
            ? () {
                params.onDismissed!();
                handleOnDismissed();
              }
            : params.onDismissed!,
      ),
    );

    return dismissible;
  }

  @override
  IEasyAnimator createAnimation({
    required BannerShowParams params,
  }) {
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
