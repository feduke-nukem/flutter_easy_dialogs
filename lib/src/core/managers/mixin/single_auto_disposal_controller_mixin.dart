import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/src/core/managers/easy_dialog_manager_base.dart';

/// Mixin that creates [AnimationController] on every [show] call and dispose it
/// on every [hide] call
mixin SingleAutoDisposalControllerMixin<S, H> on EasyDialogManagerBase<S, H> {
  /// [AnimationController] for providing animations to the dialogs,
  /// is null, when the dialog is not presented
  AnimationController? _animationController;

  @nonVirtual
  @protected
  bool get isPresented => _animationController != null;

  @protected
  @nonVirtual
  Animation<double> get animation {
    assert(
      _animationController != null,
      'animation controller is not initialized',
    );

    return _animationController!.view;
  }

  /// Called when [_animationController] is created and is ready to be used
  @protected
  void onAnimationInitialized(
    S params,
    Animation<double> animation,
  ) {}

  /// Implementation should start with calling super
  @mustCallSuper
  @protected
  void dispose() {
    _animationController!.dispose();
    _animationController = null;
  }

  /// Factory method for providing [AnimationController]
  ///
  /// Called on start of [initializeAndShow]
  @protected
  AnimationController createAnimationController(
    TickerProvider vsync,
    S params,
  );

  /// Factory method for providing dialog
  ///
  /// Called on start of [initializeAndShow]
  @protected
  Widget createDialog(
    S params,
    Animation<double> animation,
  );

  @protected
  @nonVirtual
  Future<void> initializeAndShow(S params) async {
    _animationController = createAnimationController(
      overlayController,
      params,
    );

    onAnimationInitialized(params, animation);

    await _animationController!.forward();
  }

  @protected
  @nonVirtual
  Future<void> hideAndDispose() async {
    await _animationController!.reverse();

    dispose();
  }
}
