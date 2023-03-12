import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

/// Mixin that creates [AnimationController] on every [show] call and dispose it
/// on every [hide] call
mixin SingleAutoDisposalControllerMixin<S, H> on EasyDialogManagerBase<S, H> {
  /// [AnimationController] for providing animations to the dialogs,
  /// is null, when the dialog is not presented
  @visibleForTesting
  AnimationController? animationController;

  @nonVirtual
  @protected
  @visibleForTesting
  bool get isPresented => animationController != null;

  @protected
  @nonVirtual
  @visibleForTesting
  Animation<double> get animation {
    assert(
      animationController != null,
      'animation controller is not initialized',
    );

    return animationController!.view;
  }

  /// Implementation should start with calling super
  @mustCallSuper
  @protected
  void dispose() {
    animationController!.dispose();
    animationController = null;
  }

  /// Factory method for providing [AnimationController]
  ///
  /// Called on start of [initializeAndShow]
  @protected
  AnimationController createAnimationController(
    TickerProvider vsync,
    S params,
  );

  @protected
  @nonVirtual
  Future<void> initializeAndShow(
    S params,
    EasyOverlayInsertStrategy Function(Animation<double> animation) strategy,
  ) {
    animationController = createAnimationController(
      overlayController,
      params,
    );

    super.overlayController.insertDialog(strategy(animation));

    return animationController!.forward();
  }

  @protected
  @nonVirtual
  Future<void> hideAndDispose(
    EasyOverlayRemoveStrategy strategy,
  ) async {
    await animationController!.reverse();

    super.overlayController.removeDialog(strategy);

    dispose();
  }
}
