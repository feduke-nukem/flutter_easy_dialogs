import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';

/// {@category Decorators}
/// {@category Custom}
/// `typedef` alias that is used in [EasyDialogDecorator.combine].
typedef EasyDialogDecoratorDataBuilder<D extends EasyDialogDecoratorData?> = D
    Function(Widget newChild, D previousData);

/// {@category Decorators}
/// {@category Custom}
/// This class is intended to be used within the by [EasyDialogManager].
///
/// It provides data of type [D] through the [decorate] method to
/// simplify the usage of dialogs.
///
/// This can be useful if you want to customize the appearance or behavior
/// of your `dialog's content`, and provide specific data passed through
/// the *`show/hide`* methods of an [EasyDialogManager], such as the `content`
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
/// Now you are able to use this data within [decorate] method and customize
/// your dialog as desired.
///
/// See also:
///
/// * [EasyDialogDismissible] for providing the dismissible behavior to the
/// dialog.
/// * [EasyDialogAnimator] for providing animations to the dialog.
abstract class EasyDialogDecorator<D extends EasyDialogDecoratorData?> {
  /// @nodoc
  const EasyDialogDecorator();

  /// Provides any kind of decoration to the [EasyDialogDecoratorData.dialog].
  Widget decorate(D data);

  /// Combines provided [decorators] sequentially.
  static EasyDialogDecorator<D> combine<D extends EasyDialogDecoratorData>({
    required Iterable<EasyDialogDecorator<D>> decorators,
    required EasyDialogDecoratorDataBuilder<D> nextDataBuilder,
  }) =>
      _MultipleEasyDialogDecorator<D>(
        decorators: decorators,
        nextDataBuilder: nextDataBuilder,
      );
}

/// {@category Decorators}
/// {@category Custom}
/// Core data class which is used within [EasyDialogDecorator.decorate].
class EasyDialogDecoratorData {
  /// The dialog to be decorated.
  final Widget dialog;

  /// @nodoc
  const EasyDialogDecoratorData({required this.dialog});
}

class _MultipleEasyDialogDecorator<D extends EasyDialogDecoratorData>
    extends EasyDialogDecorator<D> {
  final Iterable<EasyDialogDecorator<D>> decorators;
  final EasyDialogDecoratorDataBuilder<D> nextDataBuilder;

  const _MultipleEasyDialogDecorator({
    required this.decorators,
    required this.nextDataBuilder,
  }) : assert(decorators.length > 0, 'decorators should not be empty');

  @override
  Widget decorate(D data) {
    var result = data.dialog;

    for (final decorator in decorators) {
      result = decorator.decorate(nextDataBuilder(result, data));
    }

    return result;
  }
}
