import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialogs_position.dart';
import 'package:flutter_easy_dialogs/src/utils/position_to_animation_converter.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_banner.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_dialog.dart';

import '../animations/animations.dart';

class EasyDialogsFactory implements IEasyDialogsFactory {
  final IPositionToAnimationConverter _converter;

  const EasyDialogsFactory(this._converter);

  @override
  EasyDialogBase createBanner({
    required EasyDialogsAnimatableData data,
    required EasyDialogsAnimationType animationType,
    required EasyDialogsPosition position,
    required Widget content,
    DialogControlPanelCreatedCallback? onControlPanelCreated,
    Color? backgroundColor,
    EdgeInsets? padding,
  }) {
    final animation = _converter.convert(
      data: data,
      animationType: animationType,
      position: position,
    );

    final banner = EasyBanner(
      topSafeArea: position == EasyDialogsPosition.top ||
          position == EasyDialogsPosition.center,
      bottomSafeArea: position == EasyDialogsPosition.bottom ||
          position == EasyDialogsPosition.center,
      animation: animation,
      backgroundColor: backgroundColor,
      padding: padding,
      onCotrollPanelCreated: onControlPanelCreated,
      child: content,
    );

    return banner;
  }
}

abstract class IEasyDialogsFactory {
  EasyDialogBase createBanner({
    required EasyDialogsAnimatableData data,
    required EasyDialogsAnimationType animationType,
    required EasyDialogsPosition position,
    required Widget content,
    DialogControlPanelCreatedCallback? onControlPanelCreated,
    Color? backgroundColor,
    EdgeInsets? padding,
  });
}
