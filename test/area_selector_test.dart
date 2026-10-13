import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_sheets/features/audio/audio_panel.dart';

/// A 400×600 page; [rect] is the normalized selection, null when nothing is marked.
Future<ValueNotifier<Rect?>> _pump(WidgetTester tester, Rect? initial) async {
  final rect = ValueNotifier<Rect?>(initial);
  await tester.pumpWidget(
    MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 400,
          height: 600,
          child: ValueListenableBuilder(
            valueListenable: rect,
            builder: (context, r, _) => AreaSelector(rect: r, onChanged: (v) => rect.value = v),
          ),
        ),
      ),
    ),
  );
  return rect;
}

Future<void> _drag(WidgetTester tester, Offset from, Offset by) async {
  final g = await tester.startGesture(from);
  await tester.pump();
  await g.moveBy(by / 2);
  await tester.pump();
  await g.moveBy(by / 2);
  await tester.pump();
  await g.up();
  await tester.pump();
}

void expectRect(Rect? actual, Rect expected) {
  expect(actual, isNotNull);
  expect(actual!.left, closeTo(expected.left, 0.002));
  expect(actual.top, closeTo(expected.top, 0.002));
  expect(actual.right, closeTo(expected.right, 0.002));
  expect(actual.bottom, closeTo(expected.bottom, 0.002));
}

void main() {
  // Initial mark in pixels: (100,200)–(300,350).
  const start = Rect.fromLTRB(0.25, 200 / 600, 0.75, 350 / 600);

  testWidgets('dragging on an empty page draws a new mark', (tester) async {
    final rect = await _pump(tester, null);
    await _drag(tester, const Offset(40, 60), const Offset(200, 120));
    expectRect(rect.value, const Rect.fromLTRB(40 / 400, 60 / 600, 240 / 400, 180 / 600));
  });

  testWidgets('the bottom edge only moves the bottom', (tester) async {
    final rect = await _pump(tester, start);
    await _drag(tester, const Offset(200, 350), const Offset(30, 90));
    expectRect(rect.value, const Rect.fromLTRB(0.25, 200 / 600, 0.75, 440 / 600));
  });

  testWidgets('the right edge only moves the right side', (tester) async {
    final rect = await _pump(tester, start);
    await _drag(tester, const Offset(300, 270), const Offset(60, -40));
    expectRect(rect.value, const Rect.fromLTRB(0.25, 200 / 600, 360 / 400, 350 / 600));
  });

  testWidgets('a corner moves both directions', (tester) async {
    final rect = await _pump(tester, start);
    await _drag(tester, const Offset(100, 350), const Offset(-50, 50));
    expectRect(rect.value, const Rect.fromLTRB(50 / 400, 200 / 600, 0.75, 400 / 600));
  });

  testWidgets('dragging inside moves the mark and keeps it on the page', (tester) async {
    final rect = await _pump(tester, start);
    await _drag(tester, const Offset(200, 275), const Offset(-500, 20));
    expectRect(rect.value, const Rect.fromLTRB(0, 220 / 600, 0.5, 370 / 600));
  });

  testWidgets('dragging outside starts a new mark', (tester) async {
    final rect = await _pump(tester, start);
    await _drag(tester, const Offset(50, 450), const Offset(100, 100));
    expectRect(rect.value, const Rect.fromLTRB(50 / 400, 450 / 600, 150 / 400, 550 / 600));
  });

  testWidgets('the ✕ in the top-right corner removes the mark', (tester) async {
    final rect = await _pump(tester, start);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
    expect(rect.value, isNull);
    expect(find.byIcon(Icons.close), findsNothing);
  });
}
