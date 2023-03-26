import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

class MyDialogManager extends EasyDialogManager<EasyDialogManagerShowParams,
    EasyDialogManagerHideParams> with SingleAutoDisposalControllerMixin {
  MyDialogManager({required super.overlayController});

  int? _id;

  @override
  Future<void> hide({required EasyDialogManagerHideParams params}) => _hide();

  Future<void> _hide() =>
      hideAndDispose(BasicDialogRemoveStrategy(dialogId: _id!));

  @override
  Future<void> show({required EasyDialogManagerShowParams params}) async {
    if (isPresented) await _hide();

    await initializeAndShow(params, (animation) {
      var dialog = params.content;

      dialog = const CustomAnimator()
          .decorate(EasyDialogAnimatorData(parent: animation, dialog: dialog));

      dialog = const CustomDismissible().decorate(
        EasyDismissibleData(
          dialog: dialog,
          dismissHandler: (_) => _hide(),
        ),
      );

      return BasicDialogInsertStrategy(
        dialog: dialog,
        onInserted: (dialogId) => _id = dialogId,
      );
    });
  }

  @override
  AnimationController createAnimationController(
    TickerProvider vsync,
    EasyDialogManagerShowParams params,
  ) =>
      params.animationConfiguration.createController(vsync);
}

class CustomAnimator extends EasyDialogAnimator {
  const CustomAnimator();

  @override
  Widget decorate(EasyDialogAnimatorData data) {
    return FadeTransition(
      opacity: data.parent,
      child: data.dialog,
    );
  }
}

class CustomDismissible extends EasyDialogDismissible {
  const CustomDismissible();

  @override
  Widget decorate(EasyDismissibleData<EasyDismissiblePayload> data) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        data.dismissHandler?.call(const EasyDismissiblePayload());
        super.onDismissed?.call();
      },
      child: data.dialog,
    );
  }
}
