import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_easy_dialogs/src/core/enums/easy_dialog_type.dart';

class EasyDialogOverlayEntryProperties {
  final EasyDialogPosition dialogPosition;
  final EasyDialogType dialogType;

  const EasyDialogOverlayEntryProperties({
    required this.dialogPosition,
    required this.dialogType,
  });

  factory EasyDialogOverlayEntryProperties.other() {
    return const EasyDialogOverlayEntryProperties(
      dialogPosition: EasyDialogPosition.other,
      dialogType: EasyDialogType.other,
    );
  }

  @override
  bool operator ==(Object? other) {
    if (identical(this, other)) return true;

    return runtimeType == other.runtimeType &&
        other is EasyDialogOverlayEntryProperties &&
        dialogPosition == other.dialogPosition &&
        dialogType == other.dialogType;
  }

  @override
  int get hashCode {
    final values = [
      dialogPosition,
      dialogType,
    ];

    return Object.hashAll(values);
  }
}
