import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easy_dialogs/src/core/core.dart';

class OverlayProvider extends StatefulWidget {
  static final stateKey = GlobalKey<OverlayProviderState>();

  final Widget child;

  const OverlayProvider({
    required this.child,
    super.key,
  });

  @override
  State<OverlayProvider> createState() => OverlayProviderState();
}

class OverlayProviderState extends State<OverlayProvider>
    implements IEasyOverlay {
  late final EasyDialogsController controller;
  final _overlayKey = GlobalKey<OverlayState>();
  @visibleForTesting
  final box = EasyDialogsOverlayBox();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        key: _overlayKey,
        initialEntries: [
          EasyDialogsOverlayEntry(builder: (context) => widget.child),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = EasyDialogsController(this);
  }

  @override
  Ticker createTicker(TickerCallback onTick) =>
      _overlayKey.currentState!.createTicker(onTick);

  @override
  void insertDialog(EasyOverlayBoxInsertion<EasyDialog> insertion) =>
      _overlayKey.currentState!.insert(insertion(box));

  @override
  void removeDialog(EasyOverlayBoxRemoval<EasyDialog> removal) =>
      (removal(box))?.remove();
}
