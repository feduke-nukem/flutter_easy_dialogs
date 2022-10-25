import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/animations/easy_dialogs_animation.dart';

typedef DialogControlPanelCreatedCallback = void Function(
    IDialogControlPanel controlPanel);

/// Interface for interractiong with dialog
abstract class IDialogControlPanel {
  /// Hide this dialog
  Future<void> dismiss();

  bool get isAbleToInterract;
}

abstract class EasyDialogBase extends StatefulWidget {
  /// Content for dialog to be presented
  final Widget child;

  /// Animation
  final EasyDialogsAnimation animation;

  final DialogControlPanelCreatedCallback? onCotrollPanelCreated;

  const EasyDialogBase({
    required this.child,
    required this.animation,
    this.onCotrollPanelCreated,
    super.key,
  });

  @override
  EasyDialogBaseState createState();
}

@optionalTypeArgs
abstract class EasyDialogBaseState<T extends EasyDialogBase> extends State<T>
    with SingleTickerProviderStateMixin
    implements IDialogControlPanel {
  @protected
  @nonVirtual
  late final AnimationController animationController;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.animation.settings.duration,
      reverseDuration: widget.animation.settings.reverseDuration,
    );
    widget.onCotrollPanelCreated?.call(this);
    animationController.forward();
  }

  @override
  @mustCallSuper
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return widget.animation.animate(
      parent: animationController,
      child: buildDialog(widget.child),
    );
  }

  /// Create the dialog
  @protected
  Widget buildDialog(Widget content);

  @override
  Future<void> dismiss() async {
    if (!mounted) return;

    await animationController.reverse();
  }

  @override
  bool get isAbleToInterract => mounted;
}
