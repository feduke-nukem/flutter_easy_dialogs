import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

const customAgentName = 'customDialogAgent';
const customDialogName = 'customDialog';

class CustomDialogAgent extends EasyDialogAgentBase {
  CustomDialogAgent({required super.overlayController});

  @override
  Future<void> hide({AgentHideParams? params}) async {
    super.overlayController.removeCustomDialog(name: customDialogName);
  }

  @override
  Future<void> show({required CustomAgentShowParams params}) async {
    super.overlayController.insertCustomDialog(
          name: customDialogName,
          dialog: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200.0,
              width: 200.0,
              color: params.color,
              child: Center(child: params.content),
            ),
          ),
        );
  }
}

class CustomAgentShowParams extends AgentShowParams {
  final Color color;

  const CustomAgentShowParams({
    required super.theme,
    required super.content,
    required this.color,
  });
}
