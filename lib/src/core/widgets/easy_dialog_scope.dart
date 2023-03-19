import 'package:flutter/material.dart';

class _EasyScope<T extends EasyDialogScopeData> extends InheritedWidget {
  final T data;

  const _EasyScope({
    required super.child,
    required this.data,
    super.key,
  });

  @override
  bool updateShouldNotify(_EasyScope oldWidget) => oldWidget.data != data;
}

class EasyDialogScope<T extends EasyDialogScopeData> extends StatelessWidget {
  final Widget child;
  final T data;

  const EasyDialogScope({
    required this.child,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _EasyScope<T>(
      data: data,
      key: ValueKey(data),
      child: child,
    );
  }

  static T of<T extends EasyDialogScopeData>(
    BuildContext context, {
    bool listen = false,
  }) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<_EasyScope<T>>()!.data;
    }

    return (context
            .getElementForInheritedWidgetOfExactType<_EasyScope<T>>()!
            .widget as _EasyScope<T>)
        .data;
  }
}

abstract class EasyDialogScopeData {
  const EasyDialogScopeData();
}
