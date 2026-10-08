import 'package:flutter/material.dart';
import 'package:flutter_easy_dialogs/flutter_easy_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helper.dart';

const _targetId = 'target';
const _targetKey = ValueKey('targetChild');
const _targetRect = Rect.fromLTWH(100.0, 200.0, 50.0, 50.0);
const _contentSize = Size(20.0, 10.0);

const _alignments = [
  Alignment.topLeft,
  Alignment.topCenter,
  Alignment.topRight,
  Alignment.centerLeft,
  Alignment.center,
  Alignment.centerRight,
  Alignment.bottomLeft,
  Alignment.bottomCenter,
  Alignment.bottomRight,
];

Widget _app({Widget? target}) => MaterialApp(
      builder: FlutterEasyDialogs.builder(),
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fromRect(
              rect: _targetRect,
              child: target ??
                  const EasyTooltipTarget(
                    id: _targetId,
                    child: SizedBox.expand(key: _targetKey),
                  ),
            ),
          ],
        ),
      ),
    );

TooltipDialog _tooltip({
  Alignment alignment = TooltipDialog.defaultAlignment,
  Offset offset = Offset.zero,
  EasyDialogDecoration decoration = const EasyDialogDecoration.none(),
}) {
  return TooltipDialog(
    content: SizedBox.fromSize(key: dialogKey, size: _contentSize),
    targetId: _targetId,
    alignment: alignment,
    offset: offset,
    decoration: decoration,
  );
}

Offset _expectedTopLeft(Alignment alignment, {Offset offset = Offset.zero}) =>
    alignment.withinRect(_targetRect) -
    _tooltip(alignment: alignment).followerAnchor.alongSize(_contentSize) +
    offset;

void main() {
  testWidgets('show and hide', (widgetTester) async {
    await widgetTester.pumpWidget(_app());

    final dialog = _tooltip();
    FlutterEasyDialogs.show(dialog);
    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);
    expect(FlutterEasyDialogs.isShown(id: _targetId), isTrue);

    FlutterEasyDialogs.hide(id: _targetId);
    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsNothing);
    expect(FlutterEasyDialogs.isShown(id: _targetId), isFalse);
  });

  testWidgets('positioned relative to target for each alignment',
      (widgetTester) async {
    await widgetTester.pumpWidget(_app());

    for (final alignment in _alignments) {
      FlutterEasyDialogs.show(_tooltip(alignment: alignment));
      await widgetTester.pumpAndSettle();

      expect(
        widgetTester.getTopLeft(find.byKey(dialogKey)),
        _expectedTopLeft(alignment),
        reason: '$alignment',
      );

      FlutterEasyDialogs.hide(id: _targetId);
      await widgetTester.pumpAndSettle();
    }
  });

  testWidgets('offset is applied', (widgetTester) async {
    await widgetTester.pumpWidget(_app());

    const offset = Offset(5.0, -7.0);
    FlutterEasyDialogs.show(_tooltip(offset: offset));
    await widgetTester.pumpAndSettle();

    expect(
      widgetTester.getTopLeft(find.byKey(dialogKey)),
      _expectedTopLeft(TooltipDialog.defaultAlignment, offset: offset),
    );
  });

  testWidgets('follows target while scrolling', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: FlutterEasyDialogs.builder(),
        home: Scaffold(
          body: ListView(
            children: [
              const SizedBox(height: 300.0),
              const EasyTooltipTarget(
                id: _targetId,
                child: SizedBox(height: 50.0, key: _targetKey),
              ),
              const SizedBox(height: 1000.0),
            ],
          ),
        ),
      ),
    );

    FlutterEasyDialogs.show(_tooltip(alignment: Alignment.bottomCenter));
    await widgetTester.pumpAndSettle();

    final before = widgetTester.getTopLeft(find.byKey(dialogKey));
    expect(before.dy, 350.0);

    await widgetTester.drag(find.byType(ListView), const Offset(0.0, -100.0));
    await widgetTester.pumpAndSettle();

    expect(
      widgetTester.getTopLeft(find.byKey(dialogKey)).dy,
      widgetTester.getBottomLeft(find.byKey(_targetKey)).dy,
    );
    expect(widgetTester.getTopLeft(find.byKey(dialogKey)).dy, lessThan(350.0));
  });

  testWidgets('scrolling does not dismiss on tap outside',
      (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: FlutterEasyDialogs.builder(),
        home: Scaffold(
          body: ListView(
            children: [
              const SizedBox(height: 300.0),
              const EasyTooltipTarget(
                id: _targetId,
                child: SizedBox(height: 50.0, key: _targetKey),
              ),
              const SizedBox(height: 1000.0),
            ],
          ),
        ),
      ),
    );

    FlutterEasyDialogs.show(
      _tooltip(decoration: const EasyDialogDismiss.tapOutside()),
    );
    await widgetTester.pumpAndSettle();

    await widgetTester.drag(find.byType(ListView), const Offset(0.0, -100.0));
    await widgetTester.pumpAndSettle();

    expect(find.byKey(dialogKey), findsOneWidget);
  });

  testWidgets('works with all animations', (widgetTester) async {
    await widgetTester.pumpWidget(_app());

    const animations = <EasyDialogAnimation<TooltipDialog>>[
      EasyDialogAnimation.fade(),
      EasyDialogAnimation.expansion(),
      EasyDialogAnimation.bounce(),
      EasyDialogAnimation.slideHorizontal(),
      EasyDialogAnimation.slideVertical(),
      EasyDialogAnimation.blurBackground(),
      EasyDialogAnimation.fadeBackground(),
    ];

    for (final (animation, alignment) in [
      for (final animation in animations)
        for (final alignment in [Alignment.topCenter, Alignment.centerLeft])
          (animation, alignment),
    ]) {
      FlutterEasyDialogs.show(
        _tooltip(
          alignment: alignment,
          decoration: const TooltipShell.bubble(
            padding: EdgeInsets.zero,
            arrowLength: 0.0,
          ).chained(animation),
        ),
      );
      await widgetTester.pump(const Duration(milliseconds: 100));
      expect(find.byKey(dialogKey), findsOneWidget);
      await widgetTester.pumpAndSettle();

      expect(
        widgetTester.getTopLeft(find.byKey(dialogKey)),
        _expectedTopLeft(alignment),
        reason: '$animation $alignment',
      );

      FlutterEasyDialogs.hide(id: _targetId);
      await widgetTester.pumpAndSettle();
      expect(find.byKey(dialogKey), findsNothing, reason: '$animation');
    }
  });

  testWidgets('tap dismiss on tooltip, outside taps pass through',
      (widgetTester) async {
    var targetTaps = 0;
    await widgetTester.pumpWidget(
      _app(
        target: EasyTooltipTarget(
          id: _targetId,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => targetTaps++,
            child: const SizedBox.expand(key: _targetKey),
          ),
        ),
      ),
    );

    final result = FlutterEasyDialogs.show<int>(
      _tooltip(
        decoration: EasyDialogDismiss.tap(onDismissed: () => 1),
      ),
    );
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byKey(_targetKey), warnIfMissed: false);
    expect(targetTaps, 1);
    expect(FlutterEasyDialogs.isShown(id: _targetId), isTrue);

    await widgetTester.tap(find.byKey(dialogKey), warnIfMissed: false);
    await widgetTester.pumpAndSettle();

    expect(await result, 1);
    expect(find.byKey(dialogKey), findsNothing);
  });

  testWidgets('tap outside dismisses, tap passes through to target',
      (widgetTester) async {
    var targetTaps = 0;
    await widgetTester.pumpWidget(
      _app(
        target: EasyTooltipTarget(
          id: _targetId,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => targetTaps++,
            child: const SizedBox.expand(key: _targetKey),
          ),
        ),
      ),
    );

    final result = FlutterEasyDialogs.show<int>(
      _tooltip(
        decoration: const TooltipShell.bubble().chained(
          EasyDialogDismiss.tapOutside(onDismissed: () => 2),
        ),
      ),
    );
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(find.byKey(dialogKey), warnIfMissed: false);
    await widgetTester.pumpAndSettle();
    expect(FlutterEasyDialogs.isShown(id: _targetId), isTrue);

    await widgetTester.tap(find.byKey(_targetKey), warnIfMissed: false);
    await widgetTester.pumpAndSettle();

    expect(targetTaps, 1);
    expect(await result, 2);
    expect(find.byKey(dialogKey), findsNothing);
  });

  testWidgets('target is not mounted - throws assertion error',
      (widgetTester) async {
    await widgetTester.pumpWidget(app());

    easyOverlayState.controller.show(_tooltip());
    await widgetTester.pump();

    expect(widgetTester.takeException(), isFlutterError);

    await widgetTester.pumpAndSettle();
    expect(easyOverlayState.controller.isShown(id: _targetId), isFalse);
  });

  testWidgets('target without FlutterEasyDialogs - throws',
      (widgetTester) async {
    await widgetTester.pumpWidget(
      const EasyTooltipTarget(id: _targetId, child: SizedBox()),
    );

    expect(widgetTester.takeException(), isFlutterError);
  });

  testWidgets('hidden when target is unmounted', (widgetTester) async {
    await widgetTester.pumpWidget(_app());

    FlutterEasyDialogs.show(
      _tooltip(decoration: const EasyDialogAnimation.expansion()),
    );
    await widgetTester.pumpAndSettle();
    expect(FlutterEasyDialogs.isShown(id: _targetId), isTrue);

    await widgetTester.pumpWidget(
      _app(target: const SizedBox.expand()),
    );
    await widgetTester.pumpAndSettle();

    expect(FlutterEasyDialogs.isShown(id: _targetId), isFalse);
    expect(find.byKey(dialogKey), findsNothing);
  });

  testWidgets('shifted to stay within the screen', (widgetTester) async {
    await widgetTester.pumpWidget(
      _app(
        target: const EasyTooltipTarget(
          id: _targetId,
          child: SizedBox.expand(),
        ),
      ),
    );
    // Target is 100..150, so the 400 wide tooltip centered on it would
    // start at -75.
    FlutterEasyDialogs.show(
      TooltipDialog(
        targetId: _targetId,
        content: const SizedBox(key: dialogKey, width: 400.0, height: 10.0),
        decoration: const TooltipShell.bubble(padding: EdgeInsets.zero),
      ),
    );
    await widgetTester.pumpAndSettle();

    expect(
      widgetTester.getTopLeft(find.byKey(dialogKey)).dx,
      TooltipDialog.screenMargin.left,
    );
    // Arrow tip still touches the target.
    expect(
      widgetTester.getBottomLeft(find.byKey(dialogKey)).dy + 8.0,
      _targetRect.top,
    );
  });

  testWidgets('width is limited by the space next to the target',
      (widgetTester) async {
    await widgetTester.pumpWidget(_app());

    FlutterEasyDialogs.show(
      TooltipDialog(
        targetId: _targetId,
        alignment: Alignment.centerLeft,
        content: const SizedBox(key: dialogKey, width: 400.0, height: 10.0),
      ),
    );
    await widgetTester.pumpAndSettle();

    final rect = widgetTester.getRect(find.byKey(dialogKey));
    expect(rect.left, TooltipDialog.screenMargin.left);
    expect(rect.right, _targetRect.left);
  });

  testWidgets('the last mounted target with the same id is used',
      (widgetTester) async {
    Widget target(double left) => Positioned(
          left: left,
          top: 0.0,
          child: const EasyTooltipTarget(
            id: _targetId,
            child: SizedBox.square(dimension: 10.0),
          ),
        );

    await widgetTester.pumpWidget(_app());
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: FlutterEasyDialogs.builder(),
        home: Stack(children: [target(100.0), target(300.0)]),
      ),
    );

    FlutterEasyDialogs.show(_tooltip(alignment: Alignment.bottomLeft));
    await widgetTester.pumpAndSettle();
    expect(widgetTester.getTopLeft(find.byKey(dialogKey)).dx, 300.0);

    FlutterEasyDialogs.hide(id: _targetId);
    await widgetTester.pumpAndSettle();

    await widgetTester.pumpWidget(
      MaterialApp(
        builder: FlutterEasyDialogs.builder(),
        home: Stack(children: [target(100.0)]),
      ),
    );

    FlutterEasyDialogs.show(_tooltip(alignment: Alignment.bottomLeft));
    await widgetTester.pumpAndSettle();
    expect(widgetTester.getTopLeft(find.byKey(dialogKey)).dx, 100.0);
  });

  testWidgets('target id update re-registers the target', (widgetTester) async {
    await widgetTester.pumpWidget(
      _app(
        target: const EasyTooltipTarget(id: 'old', child: SizedBox.expand()),
      ),
    );
    await widgetTester.pumpWidget(_app());

    FlutterEasyDialogs.show(_tooltip());
    await widgetTester.pumpAndSettle();

    expect(
      widgetTester.getTopLeft(find.byKey(dialogKey)),
      _expectedTopLeft(TooltipDialog.defaultAlignment),
    );
  });

  testWidgets('bubble shell', (widgetTester) async {
    await widgetTester.pumpWidget(_app());

    const padding = EdgeInsets.all(4.0);
    const arrowLength = 6.0;
    FlutterEasyDialogs.show(
      _tooltip(
        decoration: const TooltipShell.bubble(
          padding: padding,
          arrowLength: arrowLength,
          side: BorderSide(),
          shadows: [BoxShadow()],
        ),
      ),
    );
    await widgetTester.pumpAndSettle();

    final bubble = find
        .ancestor(of: find.byKey(dialogKey), matching: find.byType(Padding))
        .first;
    const borderWidth = 1.0;

    expect(
      widgetTester.getSize(bubble),
      Size(
        _contentSize.width + padding.horizontal + borderWidth * 2,
        _contentSize.height + padding.vertical + borderWidth * 2 + arrowLength,
      ),
    );
    // Arrow tip touches the target.
    expect(
      widgetTester.getBottomLeft(bubble).dy,
      _targetRect.top,
    );
  });

  test('bubble arrow side and alignment', () {
    expect(
      TooltipBubbleBorder.arrowSideOf(Alignment.topCenter),
      AxisDirection.down,
    );
    expect(
      TooltipBubbleBorder.arrowSideOf(Alignment.bottomLeft),
      AxisDirection.up,
    );
    expect(
      TooltipBubbleBorder.arrowSideOf(Alignment.centerLeft),
      AxisDirection.right,
    );
    expect(
      TooltipBubbleBorder.arrowSideOf(Alignment.centerRight),
      AxisDirection.left,
    );
    expect(TooltipBubbleBorder.arrowSideOf(Alignment.center), isNull);

    expect(TooltipBubbleBorder.arrowAlignmentOf(Alignment.topLeft), -1.0);
    expect(TooltipBubbleBorder.arrowAlignmentOf(Alignment.centerLeft), 0.0);
  });

  test('bubble border path contains arrow tip', () {
    const border = TooltipBubbleBorder(
      arrowSide: AxisDirection.down,
      arrowLength: 10.0,
      arrowBaseWidth: 10.0,
    );
    const rect = Rect.fromLTWH(0.0, 0.0, 100.0, 60.0);
    final path = border.getOuterPath(rect);

    expect(border.dimensions, const EdgeInsets.only(bottom: 10.0));
    expect(path.contains(const Offset(50.0, 55.0)), isTrue);
    expect(path.contains(const Offset(5.0, 55.0)), isFalse);
    expect(border.scale(2.0), isA<TooltipBubbleBorder>());
  });

  test('clone', () {
    final dialog = TooltipDialog(
      content: const SizedBox.shrink(),
      targetId: _targetId,
      id: 'id',
      alignment: Alignment.centerLeft,
      offset: const Offset(1.0, 2.0),
      autoHideDuration: const Duration(seconds: 1),
      decoration: const EasyDialogAnimation.fade(),
    );
    final cloned = dialog.clone() as TooltipDialog;

    expect(cloned.id, dialog.id);
    expect(cloned.targetId, dialog.targetId);
    expect(cloned.content, dialog.content);
    expect(cloned.alignment, dialog.alignment);
    expect(cloned.offset, dialog.offset);
    expect(cloned.animationConfiguration, dialog.animationConfiguration);
    expect(cloned.autoHideDuration, dialog.autoHideDuration);
    expect(cloned.decoration, dialog.decoration);
  });

  test('id defaults to targetId', () {
    expect(_tooltip().id, _targetId);
    expect(
      const SizedBox().tooltip(targetId: _targetId, id: 'id').id,
      'id',
    );
    expect(
      EasyDialog.tooltip(content: const SizedBox(), targetId: _targetId).id,
      _targetId,
    );
  });
}
