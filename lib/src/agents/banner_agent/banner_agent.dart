import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/agents/banner_agent/banner_dismiss_params.dart';
import 'package:flutter_easy_dialogs/src/agents/banner_agent/banner_show_params.dart';
import 'package:flutter_easy_dialogs/src/agents/dialog_agent_base.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation_settings.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay.dart';
import 'package:flutter_easy_dialogs/src/utils/position_to_animation_converter.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_banner.dart';
import 'package:flutter_easy_dialogs/src/widgets/pre_built_dialogs/easy_dialog.dart';

class BannerAgent extends DialogAgentBase {
  final IPositionToAnimationConverter _positionToAnimationConverter;
  final _currentBanners = <EasyDialogPosition, IDialogControlPanel>{};

  @override
  Future<void> dismiss({
    required BannerDismissParams params,
  }) async {
    if (params.dismissAll) {
      for (final entry in _currentBanners.entries) {
        await _dismiss(
          position: entry.key,
          controlPanel: entry.value,
          overlayController: params.overlayController,
        );
      }

      return;
    }

    final controlPanel = _currentBanners[params.position];

    if (controlPanel == null) return;

    await _dismiss(
      position: params.position,
      controlPanel: controlPanel,
      overlayController: params.overlayController,
    );
  }

  BannerAgent({
    required IPositionToAnimationConverter positionToAnimationConverter,
  }) : _positionToAnimationConverter = positionToAnimationConverter;

  @override
  Future<void> show({
    required BannerShowParams params,
  }) async {
    final existingControlPanel = _currentBanners[params.position];

    if (existingControlPanel != null) {
      await existingControlPanel.dismiss();
      params.overlayController.removeDialogByTypeAndPosition(
        type: EasyDialogType.banner,
        position: params.position,
      );
    }

    late final IDialogControlPanel bannerControlPanel;

    final banner = _createBanner(
        params: params,
        onControlPanelCreated: (controlPanel) {
          bannerControlPanel = controlPanel;

          _currentBanners[params.position] = controlPanel;
        });

    final entry = params.overlayController.insertDialog(
      child: banner,
      position: params.position,
      type: EasyDialogType.banner,
    );

    if (!params.autoHide) return;

    Future.delayed(
      params.theme.easyBannerTheme.durationUntilAutoHide,
      () async {
        await bannerControlPanel.dismiss();

        if (!entry.mounted) return;

        entry.remove();
        _currentBanners.remove(params.position);
      },
    );
  }

  EasyDialogBase _createBanner({
    required BannerShowParams params,
    required DialogControlPanelCreatedCallback onControlPanelCreated,
  }) {
    final animation = _positionToAnimationConverter.convert(
      animationSettings: params.animationSettings ??
          EasyDialogsAnimationSettings(
            curve: params.theme.easyBannerTheme.animationCurve,
            duration: params.theme.easyBannerTheme.forwardDuration,
            reverseDuration: params.theme.easyBannerTheme.reverseDuration,
          ),
      animationType: params.animationType,
      position: params.position,
    );

    final banner = EasyBanner(
      animation: animation,
      topSafeArea: params.position == EasyDialogPosition.top,
      bottomSafeArea: params.position == EasyDialogPosition.bottom,
      onCotrollPanelCreated: onControlPanelCreated,
      padding: params.padding,
      child: params.content,
    );

    return banner;
  }

  Future<void> _dismiss({
    required EasyDialogPosition position,
    required IDialogControlPanel controlPanel,
    required IEasyDialogsOverlayController overlayController,
  }) async {
    await controlPanel.dismiss();

    overlayController.removeDialogByTypeAndPosition(
      type: EasyDialogType.banner,
      position: position,
    );
  }
}
