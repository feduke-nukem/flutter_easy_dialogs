import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

int? _customDialogId;

class CustomDialogManager extends EasyDialogManagerBase<CustomManagerShowParams,
    ManagerHideParamsBase?> {
  CustomDialogManager({required super.overlayController});

  @override
  Future<void> hide({ManagerHideParamsBase? params}) async {
    super.overlayController.removeDialog(
          CustomDialogRemoveStrategy(
            dialogId: _customDialogId!,
          ),
        );
  }

  @override
  Future<void> show({required CustomManagerShowParams params}) async {
    if (_customDialogId != null) {
      super.overlayController.removeDialog(
            CustomDialogRemoveStrategy(
              dialogId: _customDialogId!,
            ),
          );
    }
    super.overlayController.insertDialog(
          CustomDialogInsertStrategy(
            dialog: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200.0,
                width: 200.0,
                color: params.color,
                child: Center(child: params.content),
              ),
            ),
            onInserted: (dialogId) => _customDialogId = dialogId,
          ),
        );
  }
}

class CustomManagerShowParams extends ManagerShowParamsBase {
  final Color color;

  const CustomManagerShowParams({
    required super.theme,
    required super.content,
    required this.color,
  });
}
