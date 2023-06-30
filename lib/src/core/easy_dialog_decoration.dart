import 'package:flutter/material.dart';

import 'core.dart';

typedef EasyDialogDecorationBuilder<Dialog extends EasyDialog> = Widget
    Function(
  BuildContext context,
  Dialog dialog,
  Widget content,
);

/// {@category Decorators}
/// {@category Custom}
/// This class is intended to be used within the by [EasyDialogsController].
///
/// It provides data of type [D] through the [call] method to
/// simplify the usage of dialogs.
///
/// This can be useful if you want to customize the appearance or behavior
/// of your `dialog's content`, and provide specific data passed through
/// the *`show/hide`* methods of an [EasyDialogsController], such as the `content`
/// itself or any other data.
///
/// Example:
///
/// Define some sort of `dialog decorator` data:
///
/// ```dart
/// class SomeDialogDecoratorData extends EasyDialogDecoratorData {
///   final Color color;
///   final double height;
///   final double width;
///
///   SomeDialogDecoratorData({
///     required this.color,
///     required this.height,
///     required this.width,
///     required super.dialog,
///   });
/// }
/// ```
/// Then define any kind of `dialog decorator`:
/// ```dart
/// class SomeDialogDecorator extends EasyDialogDecorator<SomeDialogDecoratorData> {
///   @override
///   Widget decorate(SomeDialogDecoratorData data) {
///     return Container(
///       color: data.color,
///       width: data.width,
///       height: data.height,
///       child: data.dialog,
///     );
///   }
/// }
/// ```
///
/// Now you are able to use this data within [call] method and customize
/// your dialog as desired.
///
/// See also:
///
/// * [EasyDialogDismiss] for providing the dismissible behavior to the
/// dialog.
/// * [EasyDialogAnimation] for providing animations to the dialog.
abstract base class EasyDialogDecoration<Dialog extends EasyDialog>
    with EasyDialogLifecycle {
  /// @nodoc
  const EasyDialogDecoration();

  const factory EasyDialogDecoration.none() = _None;

  const factory EasyDialogDecoration.combine(
    List<EasyDialogDecoration> decorations,
  ) = _MultiDecoration;

  const factory EasyDialogDecoration.chain(
    EasyDialogDecoration first,
    EasyDialogDecoration second,
  ) = _ChainedDecoration;

  static EasyDialogDecoration<Dialog> builder<Dialog extends EasyDialog>(
    EasyDialogDecorationBuilder<Dialog> builder, {
    VoidCallback? onInit,
    VoidCallback? onShow,
    VoidCallback? onHide,
    VoidCallback? onDispose,
  }) =>
      _BuilderDecoration<Dialog>(
        builder,
        onInitCallback: onInit,
        onShowCallback: onShow,
        onHideCallback: onHide,
        onDisposeCallback: onDispose,
      );

  @protected
  Widget call(Dialog dialog, Widget content);

  EasyDialogDecoration operator +(EasyDialogDecoration other) =>
      this.then(other);

  EasyDialogDecoration then(EasyDialogDecoration other) =>
      EasyDialogDecoration.chain(this, other);
}

final class _MultiDecoration<Dialog extends EasyDialog>
    extends EasyDialogDecoration<Dialog> {
  final List<EasyDialogDecoration> _decorations;
  const _MultiDecoration(this._decorations);

  @override
  void init() {
    super.init();

    for (final decoration in _decorations) {
      decoration.init();
    }
  }

  @override
  void onShow() {
    super.onShow();

    for (final decoration in _decorations) {
      decoration.onShow();
    }
  }

  @override
  void onHide() {
    super.onHide();

    for (final decoration in _decorations) {
      decoration.onHide();
    }
  }

  @override
  void dispose() {
    super.dispose();

    for (final decoration in _decorations) {
      decoration.dispose();
    }
  }

  @override
  Widget call(EasyDialog dialog, Widget content) => _decorations.fold(
        content,
        (previousValue, decoration) => decoration(dialog, previousValue),
      );
}

final class _None<Dialog extends EasyDialog>
    extends EasyDialogDecoration<Dialog> {
  const _None();

  @override
  Widget call(EasyDialog dialog, Widget content) => content;
}

final class _ChainedDecoration<Dialog extends EasyDialog>
    extends EasyDialogDecoration<Dialog> {
  final EasyDialogDecoration _first;
  final EasyDialogDecoration _second;

  const _ChainedDecoration(this._first, this._second);

  @override
  void init() {
    super.init();
    _first.init();
    _second.init();
  }

  @override
  void onShow() {
    super.onShow();
    _first.onShow();
    _second.onShow();
  }

  @override
  void onHide() {
    super.onHide();
    _first.onHide();
    _second.onHide();
  }

  @override
  void dispose() {
    super.dispose();
    _first.dispose();
    _second.dispose();
  }

  @override
  Widget call(EasyDialog dialog, Widget content) =>
      _second(dialog, _first(dialog, content));
}

final class _BuilderDecoration<Dialog extends EasyDialog>
    extends EasyDialogDecoration<Dialog> {
  final EasyDialogDecorationBuilder<Dialog> builder;
  final VoidCallback? onInitCallback;
  final VoidCallback? onShowCallback;
  final VoidCallback? onHideCallback;
  final VoidCallback? onDisposeCallback;

  const _BuilderDecoration(
    this.builder, {
    this.onInitCallback,
    this.onShowCallback,
    this.onHideCallback,
    this.onDisposeCallback,
  });

  @override
  void init() {
    super.init();
    onInitCallback?.call();
  }

  @override
  void onShow() {
    super.onShow();
    onShowCallback?.call();
  }

  @override
  void onHide() {
    super.onHide();
    onHideCallback?.call();
  }

  @override
  void dispose() {
    super.dispose();
    onDisposeCallback?.call();
  }

  @override
  Widget call(Dialog dialog, Widget content) {
    return Builder(
      builder: (context) => builder(
        context,
        dialog,
        content,
      ),
    );
  }
}
