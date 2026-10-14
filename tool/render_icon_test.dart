// Renders the app icon sources into assets/icon/. Run with:
//   flutter test tool/render_icon_test.dart
// then `dart run flutter_launcher_icons` to generate the platform icons.
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const seed = Color(0xFF4C5FD5);
const size = 1024.0;

void _paintBackground(Canvas c) {
  c.drawRect(
    const Rect.fromLTWH(0, 0, size, size),
    Paint()
      ..shader = ui.Gradient.linear(Offset.zero, const Offset(size, size), [
        const Color(0xFF6274EC),
        const Color(0xFF3443B0),
      ]),
  );
}

/// The sheet and notes, kept inside the adaptive-icon safe zone (centre ~66%).
void _paintForeground(Canvas c) {
  // Sheet of paper with a soft shadow.
  final sheet = RRect.fromRectAndRadius(const Rect.fromLTWH(302, 232, 420, 560), const Radius.circular(44));
  c.drawRRect(
    sheet.shift(const Offset(0, 14)),
    Paint()
      ..color = const Color(0x55000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22),
  );
  c.drawRRect(sheet, Paint()..color = Colors.white);

  // Staff lines.
  final line = Paint()
    ..color = seed.withValues(alpha: 0.28)
    ..strokeWidth = 9
    ..strokeCap = StrokeCap.round;
  for (var i = 0; i < 5; i++) {
    final y = 352.0 + i * 44;
    c.drawLine(Offset(352, y), Offset(672, y), line);
  }

  // Two beamed eighth notes.
  final ink = Paint()..color = seed;
  void head(Offset center) {
    c.save();
    c.translate(center.dx, center.dy);
    c.rotate(-20 * math.pi / 180);
    c.drawOval(Rect.fromCenter(center: Offset.zero, width: 104, height: 74), ink);
    c.restore();
  }

  const h1 = Offset(420, 664), h2 = Offset(598, 620);
  head(h1);
  head(h2);
  const stem = 15.0;
  final s1x = h1.dx + 44, s2x = h2.dx + 44;
  const top1 = 380.0, top2 = 336.0;
  c.drawRect(Rect.fromLTRB(s1x - stem, top1, s1x, h1.dy - 8), ink);
  // Starts below the sloped beam's top edge so no corner sticks out.
  c.drawRect(Rect.fromLTRB(s2x - stem, top2 + 12, s2x, h2.dy - 8), ink);
  final beam = Path()
    ..moveTo(s1x - stem, top1)
    ..lineTo(s2x, top2)
    ..lineTo(s2x, top2 + 46)
    ..lineTo(s1x - stem, top1 + 46)
    ..close();
  c.drawPath(beam, ink);
}

Future<void> _save(WidgetTester tester, String path, void Function(Canvas) paint) async {
  await tester.runAsync(() async {
    final rec = ui.PictureRecorder();
    paint(Canvas(rec));
    final img = await rec.endRecording().toImage(size.toInt(), size.toInt());
    final png = await img.toByteData(format: ui.ImageByteFormat.png);
    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(png!.buffer.asUint8List());
  });
}

void main() {
  testWidgets('render icon', (tester) async {
    // Full-square icon (legacy Android launchers, iOS): no safe zone, so the sheet can be bigger.
    await _save(tester, 'assets/icon/icon.png', (c) {
      _paintBackground(c);
      c.translate(size / 2, size / 2);
      c.scale(1.3);
      c.translate(-size / 2, -size / 2);
      _paintForeground(c);
    });
    // Adaptive-icon foreground: flutter_launcher_icons insets it by 16% on each side,
    // so the artwork is drawn larger here to end up at a normal size.
    void foreground(Canvas c) {
      c.translate(size / 2, size / 2);
      c.scale(1.6);
      c.translate(-size / 2, -size / 2);
      _paintForeground(c);
    }

    await _save(tester, 'assets/icon/foreground.png', foreground);

    // Optional preview of the adaptive icon as a round launcher shows it.
    final preview = Platform.environment['ICON_PREVIEW'];
    if (preview != null) {
      await _save(tester, preview, (c) {
        c.clipPath(Path()..addOval(const Rect.fromLTWH(0, 0, size, size)));
        _paintBackground(c);
        c.translate(size * 0.16, size * 0.16);
        c.scale(0.68);
        foreground(c);
      });
    }
  });
}
