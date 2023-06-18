import 'package:flutter_easy_dialogs/src/core/easy_dialog_animator.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_dismissible.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialogs_controller.dart';

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
/// * [EasyDialogDismissible] for providing the dismissible behavior to the
/// dialog.
/// * [EasyDialogAnimator] for providing animations to the dialog.
abstract base class EasyDialogDecorator with EasyDialogLifecycle {
  /// @nodoc
  const EasyDialogDecorator();

  EasyDialog call(covariant EasyDialog dialog);

  /// Combines provided [decorators] sequentially.
  const factory EasyDialogDecorator.combine(
    Iterable<EasyDialogDecorator> decorators,
  ) = ManyDecorators;
}
