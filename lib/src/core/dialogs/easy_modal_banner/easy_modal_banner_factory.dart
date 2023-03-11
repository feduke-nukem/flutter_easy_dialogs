import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// [EasyModalBanner] factory
class EasyModalBannerFactory
    extends IEasyDialogFactory<EasyModalBannerShowParams> {
  @override
  IEasyAnimator createAnimation({required EasyModalBannerShowParams params}) {
    final animation = EasyFullScreenAnimation(
      curve: params.animationSettings?.curve,
      contentAnimationType: params.contentAnimationType,
      backgroundAnimationType: params.backgroundAnimationType,
      backgroundColor: params.backgroundColor,
      customBackgroundAnimation: params.customBackgroundAnimation,
      customContentAnimation: params.customContentAnimation,
    );

    return animation;
  }

  @override
  Widget createDialog({required EasyModalBannerShowParams params}) {
    final modalBanner = EasyModalBanner(
      boxDecoration: params.decoration,
      margin: params.margin,
      padding: params.padding,
      child: params.content,
    );

    return modalBanner;
  }

  @override
  IEasyDismissor createDismissible({
    required EasyModalBannerShowParams params,
    VoidCallback? handleOnDismissed,
  }) {
    return EasyGestureDismissible(
      onDismissed: handleOnDismissed != null
          ? () {
              params.onDismissed!();
              handleOnDismissed();
            }
          : params.onDismissed!,
    );
  }
}
