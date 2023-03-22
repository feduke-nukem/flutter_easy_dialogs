import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/src/core/easy_dialog_manager.dart';
import 'package:flutter_easy_dialogs/src/core/widgets/easy_dialog_scope.dart';
import 'package:flutter_easy_dialogs/src/util/easy_dialog_scope_x.dart';

/// This is a [Widget] that is intended to be used within the [EasyDialogScope].
///
/// It provides data of type [D] through the [build] method to
/// simplify the usage of dialogs.
///
/// This can be useful if you want to customize the appearance or behavior
/// of your `dialog's content`, and provide specific data passed through
/// the show/hide methods of an [EasyDialogManager], such as the `content`
/// itself or any other data.
///
/// Example:
///
/// Define some sort of `dialog-scope` data:
/// ```dart
/// class SomePositionedScopeData extends EasyDialogScopeData {
///   final EasyDialogPosition position;
///   final Widget content;
///   final Color shellColor;
///   final EdgeInsets shellPadding;
///
///   SomePositionedScopeData(
///     this.position,
///     this.content,
///     this.shellColor,
///     this.shellPadding,
///   );
/// }
/// ```
/// Define any kind of shell:
///
/// ```dart
/// class SomeDialogShell extends EasyDialogShell<SomePositionedScopeData> {
///   const SomeDialogShell({super.key});
///
///   @override
///   Widget build(BuildContext context, SomePositionedScopeData data) {
///     return Container(
///       alignment: data.position.toAlignment(),
///       padding: data.shellPadding,
///       color: data.shellColor,
///       width: 400.0,
///       height: 400.0,
///       child: data.content,
///     );
///   }
/// }
///
/// ```
/// Now you are able to use the data defined above, right in the build method.
///
/// If you are looking for the functionality described above
/// (which involves not only getting the [EasyDialogScopeData]),
/// it is strongly recommended to inherit from [EasyDialogShell]
/// instead of [EasyDialogWidget] due to the possibility of future improvements
/// and expansion of functionality.
abstract class EasyDialogWidget<D extends EasyDialogScopeData> extends Widget {
  /// @nodoc
  const EasyDialogWidget({super.key});

  @override
  EasyDialogElement<D> createElement() => EasyDialogElement<D>(this);

  /// @nodoc
  @protected
  Widget build(BuildContext context, D data);
}

/// [Element] that is intended to bes used with [EasyDialogWidget].
///
/// It provides the [EasyDialogScopeData] to the [EasyDialogWidget].
///
class EasyDialogElement<D extends EasyDialogScopeData>
    extends ComponentElement {
  @override
  EasyDialogWidget<D> get widget => super.widget as EasyDialogWidget<D>;

  /// @nodoc
  EasyDialogElement(super.widget);

  @override
  Widget build() => widget.build(this, readDialog<D>());
}

/// This is the wrapper that provides some sort of shape
/// to the content of the dialog.
///
/// It is not mandatory, but it could be very handy to apply some additional
/// components around the provided content.
///
/// * See also [EasyDialogWidget].
abstract class EasyDialogShell<D extends EasyDialogScopeData>
    extends EasyDialogWidget<D> {
  /// @nodoc
  const EasyDialogShell({super.key});
}
