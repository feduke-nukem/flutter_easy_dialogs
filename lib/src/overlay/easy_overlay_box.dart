import 'package:flutter/widgets.dart';
import 'package:flutter_easy_dialogs/src/core/i_easy_overlay_controller.dart';
import 'package:flutter_easy_dialogs/src/overlay/easy_dialogs_overlay_entry.dart';

/// Implementation of [IEasyOverlayBox].
class EasyOverlayBox implements IEasyOverlayBox {
  @visibleForTesting
  final currentEntries = <Object, Object?>{};

  /// Indicator for understanding if app entry is already inserted.
  EasyOverlayAppEntry? appEntry;

  @override
  T putIfAbsent<T>(Object key, T Function() ifAbsent) =>
      currentEntries.putIfAbsent(key, ifAbsent) as T;

  @override
  T? get<T>(Object key) => currentEntries[key] as T?;

  @override
  void put(Object key, Object value) => currentEntries[key] = value;

  @override
  T? remove<T>(Object key) => currentEntries.remove(key) as T?;
}
