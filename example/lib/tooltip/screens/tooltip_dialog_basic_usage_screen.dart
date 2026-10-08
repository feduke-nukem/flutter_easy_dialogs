import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';

const _alignments = <String, Alignment>{
  'topCenter': Alignment.topCenter,
  'bottomCenter': Alignment.bottomCenter,
  'centerLeft': Alignment.centerLeft,
  'centerRight': Alignment.centerRight,
  'topLeft': Alignment.topLeft,
  'topRight': Alignment.topRight,
  'bottomLeft': Alignment.bottomLeft,
  'bottomRight': Alignment.bottomRight,
};

const _animations = <String, EasyDialogAnimation<TooltipDialog>>{
  'fade': EasyDialogAnimation.fade(),
  'bounce': EasyDialogAnimation.bounce(curve: Curves.easeOut),
  'expansion': EasyDialogAnimation.expansion(),
  'slideVertical': EasyDialogAnimation.slideVertical(),
  'blurBackground': EasyDialogAnimation.blurBackground(),
  'fadeBackground': EasyDialogAnimation.fadeBackground(),
};

enum _Content { short, long, rich }

class TooltipDialogBasicUsageScreen extends StatefulWidget {
  const TooltipDialogBasicUsageScreen({super.key});

  @override
  State<TooltipDialogBasicUsageScreen> createState() =>
      _TooltipDialogBasicUsageScreenState();
}

class _TooltipDialogBasicUsageScreenState
    extends State<TooltipDialogBasicUsageScreen> {
  var _alignment = _alignments.values.first;
  var _animation = _animations.values.first;
  var _content = _Content.short;
  var _isAutoHide = false;
  var _isTapOutside = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tooltip dialogs'),
        actions: [
          EasyTooltipTarget(
            id: 'info',
            child: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _show('info', 'App bar tooltip'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Wrap(
            spacing: 16.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DropdownButton<Alignment>(
                value: _alignment,
                items: _alignments.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.value,
                        child: Text(e.key),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _alignment = value!),
              ),
              DropdownButton<EasyDialogAnimation<TooltipDialog>>(
                value: _animation,
                items: _animations.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.value,
                        child: Text(e.key),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _animation = value!),
              ),
              DropdownButton<_Content>(
                value: _content,
                items: _Content.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text('${e.name} content'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _content = value!),
              ),
              InkWell(
                onTap: () => setState(() => _isAutoHide = !_isAutoHide),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IgnorePointer(
                      child: Checkbox(value: _isAutoHide, onChanged: (_) {}),
                    ),
                    const Text('Auto hide'),
                  ],
                ),
              ),
              InkWell(
                onTap: () => setState(() => _isTapOutside = !_isTapOutside),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IgnorePointer(
                      child: Checkbox(value: _isTapOutside, onChanged: (_) {}),
                    ),
                    const Text('Tap outside'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () =>
                    FlutterEasyDialogs.hideWhere<TooltipDialog>((_) => true),
                child: const Text('Hide all'),
              ),
            ],
          ),
          const Divider(),
          const Text('Tap an item. Tooltips follow items while scrolling.'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              itemCount: 30,
              itemBuilder: (context, index) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: EasyTooltipTarget(
                    id: index,
                    child: FilledButton(
                      onPressed: () => _show(index, 'Tooltip #$index'),
                      child: Text('Item #$index'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _show(Object targetId, String text) {
    // Tap on the target toggles its tooltip.
    if (FlutterEasyDialogs.isShown(id: targetId)) {
      FlutterEasyDialogs.hide(id: targetId);

      return;
    }

    final content = switch (_content) {
      _Content.short => Text(text),
      _Content.long => Text(
          '$text. Long text wraps to fit the screen, and the tooltip '
          'is shifted so it does not go beyond the screen edges.',
        ),
      _Content.rich => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lightbulb, color: Colors.amber),
            const SizedBox(width: 8.0),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text('Any widget can be shown.'),
                ],
              ),
            ),
            TextButton(
              onPressed: () => FlutterEasyDialogs.hide(id: targetId),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: const Text('Got it'),
            ),
          ],
        ),
    };

    var dialog = content
        .tooltip(
          targetId: targetId,
          alignment: _alignment,
          autoHideDuration: _isAutoHide ? const Duration(seconds: 2) : null,
        )
        .decorate(const TooltipShell.bubble())
        .decorate(const EasyDialogDismiss.animatedTap());

    // Before the animation, so full screen backgrounds count as outside.
    if (_isTapOutside) dialog = dialog.tapOutside();

    dialog.decorate(_animation).show();
  }
}
