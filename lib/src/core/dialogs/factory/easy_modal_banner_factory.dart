import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/animations/pre_built/fullscreen/easy_fullscreen_animation.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/pre_built/easy_modal_banner.dart/easy_modal_banner.dart';
import 'package:flutter_easy_dialogs/src/core/dialogs/pre_built/easy_modal_banner.dart/easy_modal_banner_show_params.dart';
import 'package:flutter_easy_dialogs/src/core/dismissibles/pre_built/easy_gesture_dismissible.dart';

class EasyModalBannerFactory extends IEasyDialogFactory {
  @override
  IEasyAnimator createAnimation({required EasyModalBannerShowParams params}) {
    final animation = EasyFullScreenAnimation(
      curve: params.animationSettings?.curve,
      contentAnimationType: params.contentAnimationType,
      backgroundColor: params.backgroundColor,
      backgroungAnimationType: params.backgroungAnimationType,
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

  @override
  final EasyDialogType dialogType = EasyDialogType.banner;
}
