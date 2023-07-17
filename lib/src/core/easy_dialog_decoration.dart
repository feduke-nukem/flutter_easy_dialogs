part of 'easy_dialogs_controller.dart';

typedef EasyDialogDecorationBuilder<Dialog extends EasyDialog> = Widget
    Function(
  BuildContext context,
  Dialog dialog,
);

/// {@category Decorations}
/// {@category Migration guide from 2.x to 3.x}
/// {@template easy_dialog_decoration}
/// This class is intended to be used by [D] dialog to apply some decorations.
///
/// This can be useful if you want to customize the appearance or behavior
/// of your `dialog's content`.
///
/// Example:
///
/// Define some sort of `dialog decoration`:
///
/// ```dart
/// final class CustomPositionedAnimation
///   extends EasyDialogDecoration<PositionedDialog> {
/// @override
/// Widget call(EasyDialog dialog) {
///   final animation = dialog.context.animation;
///
///   final offset = Tween<Offset>(
///     begin: const Offset(0.0, 1.0),
///     end: const Offset(0.0, 0.0),
///   ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(animation);
///   return AnimatedBuilder(
///     animation: animation,
///     builder: (_, __) => Stack(
///       children: [
///         Positioned.fill(
///           child: ColoredBox(
///             color: Colors.black.withOpacity(
///               animation.value.clamp(0.0, 0.6),
///             ),
///           ),
///         ),
///         Align(
///           alignment: Alignment.bottomCenter,
///           child: SlideTransition(position: offset, child: dialog.content),
///         ),
///       ],
///     ),
///   );
/// }
/// }
/// ```
///
/// See also:
///
/// * [EasyDialogDismiss] for providing the dismissible behavior to the
/// dialog.
/// * [EasyDialogAnimation] for providing animations to the dialog.
/// {@endtemplate}
abstract base class EasyDialogDecoration<D extends EasyDialog>
    with EasyDialogLifecycle {
  /// @nodoc
  const EasyDialogDecoration();

  /// No decoration at all.
  const factory EasyDialogDecoration.none() = _None<D>;

  /// {@template easy_dialog_decoration.combine}
  /// Combine multiple decorations.
  /// {@endtemplate}
  const factory EasyDialogDecoration.combine(
    List<EasyDialogDecoration<D>> decorations,
  ) = _MultiDecoration<D>;

  /// {@template easy_dialog_decoration.chain}
  /// Chain two decorations.
  /// {@endtemplate}
  const factory EasyDialogDecoration.chain(
    EasyDialogDecoration<D> first,
    EasyDialogDecoration<D> second,
  ) = _ChainedDecoration<D>;

  /// Use a builder function to create a decoration.
  const factory EasyDialogDecoration.builder(
    EasyDialogDecorationBuilder<D> builder, {
    VoidCallback? onInit,
    VoidCallback? onShow,
    VoidCallback? onShown,
    VoidCallback? onHide,
    VoidCallback? onHidden,
    VoidCallback? onDispose,
  }) = _BuilderDecoration<D>;

  /// Get the decoration of type [T] from the [context].
  static T of<T extends EasyDialogDecoration>(EasyDialogContext context) =>
      maybeOf<T>(context)!;

  /// Get the optional decoration of type [T] from the [context].
  static T? maybeOf<T extends EasyDialogDecoration>(
    EasyDialogContext context,
  ) =>
      context.getDecorationOfExactType<T>();

  @mustCallSuper
  @protected
  D _decorate(D dialog) {
    dialog.context._registerDecoration(this);

    final cloned = dialog._copyWith(
      content: this.call(dialog),
    );

    return cloned as D;
  }

  /// Implement this method to decorate the [dialog] content appearance.
  @protected
  Widget call(D dialog);
}

final class _MultiDecoration<D extends EasyDialog>
    extends EasyDialogDecoration<D> {
  final List<EasyDialogDecoration<D>> _decorations;
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
  Widget call(D dialog) => _decorations
      .fold(
        dialog,
        (dialog, decoration) => decoration._decorate(dialog),
      )
      .content;
}

final class _None<D extends EasyDialog> extends EasyDialogDecoration<D> {
  const _None();

  @override
  Widget call(D dialog) => dialog.content;
}

final class _ChainedDecoration<D extends EasyDialog>
    extends EasyDialogDecoration<D> {
  final EasyDialogDecoration<D> _first;
  final EasyDialogDecoration<D> _second;

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
  Widget call(D dialog) {
    return _second._decorate(_first._decorate(dialog)).content;
  }
}

final class _BuilderDecoration<D extends EasyDialog>
    extends EasyDialogDecoration<D> {
  final VoidCallback? _onInit;
  final VoidCallback? _onShown;
  final VoidCallback? _onShow;
  final VoidCallback? _onHide;
  final VoidCallback? _onHidden;
  final VoidCallback? _onDispose;
  final EasyDialogDecorationBuilder<D> builder;

  const _BuilderDecoration(
    this.builder, {
    VoidCallback? onInit,
    VoidCallback? onShow,
    VoidCallback? onShown,
    VoidCallback? onHide,
    VoidCallback? onHidden,
    VoidCallback? onDispose,
  })  : _onDispose = onDispose,
        _onHidden = onHidden,
        _onHide = onHide,
        _onShow = onShow,
        _onShown = onShown,
        _onInit = onInit;

  @override
  void init() {
    super.init();
    _onInit?.call();
  }

  @override
  void onShow() {
    super.onShow();
    _onShow?.call();
  }

  @override
  void onShown() {
    super.onShown();
    _onShown?.call();
  }

  @override
  void onHide() {
    super.onHide();
    _onHide?.call();
  }

  @override
  void onHidden() {
    super.onHidden();
    _onHidden?.call();
  }

  @override
  void dispose() {
    super.dispose();
    _onDispose?.call();
  }

  @override
  Widget call(D dialog) {
    return Builder(
      builder: (context) => builder(
        context,
        dialog,
      ),
    );
  }
}

extension EasyDialogDecorationX<D extends EasyDialog>
    on EasyDialogDecoration<D> {
  /// {@macro easy_dialog_decoration.chain}
  EasyDialogDecoration<D> chained(EasyDialogDecoration<D> other) =>
      EasyDialogDecoration<D>.chain(this, other);

  /// {@macro easy_dialog_decoration.combine}
  EasyDialogDecoration<D> combined(
    List<EasyDialogDecoration<D>> others,
  ) =>
      EasyDialogDecoration<D>.combine([this, ...others]);
}
