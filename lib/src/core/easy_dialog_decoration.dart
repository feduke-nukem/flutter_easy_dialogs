part of 'easy_dialogs_controller.dart';

typedef EasyDialogDecorationBuilder<Dialog extends EasyDialog> = Widget
    Function(
  BuildContext context,
  EasyDialogContext<Dialog> dialogContext,
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

  const factory EasyDialogDecoration.none() = _None<Dialog>;

  const factory EasyDialogDecoration.combine(
    List<EasyDialogDecoration<Dialog>> decorations,
  ) = _MultiDecoration<Dialog>;

  const factory EasyDialogDecoration.chain(
    EasyDialogDecoration<Dialog> first,
    EasyDialogDecoration<Dialog> second,
  ) = _ChainedDecoration<Dialog>;

  static EasyDialogDecoration<Dialog> builder<Dialog extends EasyDialog>(
    EasyDialogDecorationBuilder<Dialog> builder, {
    VoidCallback? onInit,
    VoidCallback? onShow,
    VoidCallback? onShown,
    VoidCallback? onHide,
    VoidCallback? onHidden,
    VoidCallback? onDispose,
  }) =>
      _BuilderDecoration<Dialog>(
        builder,
        onInitCallback: onInit,
        onShowCallback: onShow,
        onShownCallback: onShown,
        onHideCallback: onHide,
        onHiddenCallback: onHidden,
        onDisposeCallback: onDispose,
      );

  static T of<D extends EasyDialog, T extends EasyDialogDecoration<D>>(
    EasyDialogContext<D> dialogContext,
  ) =>
      dialogContext.getDecorationOfExactType<T>()!;

  static T? maybeOf<D extends EasyDialog, T extends EasyDialogDecoration<D>>(
    EasyDialogContext<D> dialogContext,
  ) =>
      dialogContext.getDecorationOfExactType<T>();

  @mustCallSuper
  @protected
  EasyDialogContext<Dialog> _decorate(EasyDialogContext<Dialog> dialogContext) {
    dialogContext._registerDecoration(this);

    return dialogContext._updateWithContent(
      call(dialogContext),
    );
  }

  @protected
  Widget call(EasyDialogContext<Dialog> dialogContext);

  EasyDialogDecoration<Dialog> operator +(EasyDialogDecoration<Dialog> other) =>
      this.then(other);

  EasyDialogDecoration<Dialog> then(EasyDialogDecoration<Dialog> other) =>
      EasyDialogDecoration<Dialog>.chain(this, other);

  EasyDialogDecoration<Dialog> combineWith(
    List<EasyDialogDecoration<Dialog>> others,
  ) =>
      EasyDialogDecoration<Dialog>.combine([this, ...others]);
}

final class _MultiDecoration<Dialog extends EasyDialog>
    extends EasyDialogDecoration<Dialog> {
  final List<EasyDialogDecoration<Dialog>> _decorations;
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
  void onShown() {
    super.onShown();

    for (final decoration in _decorations) {
      decoration.onShown();
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
  void onHidden() {
    super.onHidden();

    for (final decoration in _decorations) {
      decoration.onHidden();
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
  Widget call(EasyDialogContext<Dialog> dialogContext) => _decorations
      .fold(
        dialogContext,
        (context, decoration) => decoration._decorate(context),
      )
      .content;
}

final class _None<Dialog extends EasyDialog>
    extends EasyDialogDecoration<Dialog> {
  const _None();

  @override
  Widget call(EasyDialogContext<Dialog> dialogContext) => dialogContext.content;
}

final class _ChainedDecoration<Dialog extends EasyDialog>
    extends EasyDialogDecoration<Dialog> {
  final EasyDialogDecoration<Dialog> _first;
  final EasyDialogDecoration<Dialog> _second;

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
  void onShown() {
    super.onShown();

    _first.onShown();
    _second.onShown();
  }

  @override
  void onHide() {
    super.onHide();

    _first.onHide();
    _second.onHide();
  }

  @override
  void onHidden() {
    super.onHidden();

    _first.onHidden();
    _second.onHidden();
  }

  @override
  void dispose() {
    super.dispose();

    _first.dispose();
    _second.dispose();
  }

  @override
  Widget call(EasyDialogContext<Dialog> dialogContext) {
    return _second._decorate(_first._decorate(dialogContext)).content;
  }
}

final class _BuilderDecoration<Dialog extends EasyDialog>
    extends EasyDialogDecoration<Dialog> {
  final EasyDialogDecorationBuilder<Dialog> builder;
  final VoidCallback? onInitCallback;
  final VoidCallback? onShownCallback;
  final VoidCallback? onShowCallback;
  final VoidCallback? onHideCallback;
  final VoidCallback? onHiddenCallback;
  final VoidCallback? onDisposeCallback;

  const _BuilderDecoration(
    this.builder, {
    this.onInitCallback,
    this.onShowCallback,
    this.onShownCallback,
    this.onHideCallback,
    this.onHiddenCallback,
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
    onShownCallback?.call();
  }

  @override
  void onShown() {
    super.onShown();
    onShownCallback?.call();
  }

  @override
  void onHide() {
    super.onHide();
    onHideCallback?.call();
  }

  @override
  void onHidden() {
    super.onHidden();
    onHiddenCallback?.call();
  }

  @override
  void dispose() {
    super.dispose();
    onDisposeCallback?.call();
  }

  @override
  Widget call(EasyDialogContext<Dialog> dialogContext) {
    return Builder(
      builder: (context) => builder(
        context,
        dialogContext,
      ),
    );
  }
}
