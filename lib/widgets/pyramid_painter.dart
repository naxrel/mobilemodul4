import 'package:flutter/material.dart';
import 'dart:math' as math;


class PyramidPainter extends CustomPainter {
  final double rotateAngle;
  final double scale;
  final double base;
  final double height;

  PyramidPainter({
    required this.rotateAngle,
    required this.scale,
    required this.base,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 10;

    // Normalize values for drawing
    final maxDim = math.max(base, height).clamp(1.0, double.infinity);
    final drawScale = (size.width * 0.28 / maxDim) * scale;

    final b = base * drawScale;
    final h = height * drawScale;

    // 3D isometric-like projection
    final cos = math.cos(rotateAngle);
    final sin = math.sin(rotateAngle);

    // Base square corners (rotated)
    final halfB = b / 2;
    final tilt = 0.4; // vertical compression for perspective

    Offset project(double x, double z) {
      final rx = x * cos - z * sin;
      final rz = x * sin + z * cos;
      return Offset(cx + rx, cy + rz * tilt);
    }

    final bfl = project(-halfB, halfB);  // front-left
    final bfr = project(halfB, halfB);   // front-right
    final bbl = project(-halfB, -halfB); // back-left
    final bbr = project(halfB, -halfB);  // back-right
    final apex = Offset(cx, cy - h);     // apex

    // ── Draw grid floor ──
    final gridPaint = Paint()
      ..color = const Color(0xFFE8A020).withOpacity(0.06)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = -4; i <= 4; i++) {
      final step = b * 0.3 * i;
      canvas.drawLine(
        Offset(cx + step - b * 1.5, cy + step * tilt + b * tilt * 0.8),
        Offset(cx + step + b * 1.5, cy + step * tilt + b * tilt * 0.8),
        gridPaint,
      );
    }

    // ── Shadow ellipse ──
    final shadowPaint = Paint()
      ..color = const Color(0xFFE8A020).withOpacity(0.08)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy + halfB * tilt + 2),
        width: b * 1.5,
        height: b * tilt * 0.6,
      ),
      shadowPaint,
    );

    // ── Back faces (darker) ──
    final backFacePaint = Paint()
      ..color = const Color(0xFF1A1100)
      ..style = PaintingStyle.fill;

    // Back-left triangle
    final backLeft = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(bbl.dx, bbl.dy)
      ..lineTo(bfl.dx, bfl.dy)
      ..close();
    canvas.drawPath(backLeft, backFacePaint);

    // Back-right triangle
    final backRight = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(bbr.dx, bbr.dy)
      ..lineTo(bbl.dx, bbl.dy)
      ..close();
    canvas.drawPath(backRight, backFacePaint);

    // ── Base ──
    final basePaint = Paint()
      ..color = const Color(0xFF2A1800)
      ..style = PaintingStyle.fill;

    final basePath = Path()
      ..moveTo(bfl.dx, bfl.dy)
      ..lineTo(bfr.dx, bfr.dy)
      ..lineTo(bbr.dx, bbr.dy)
      ..lineTo(bbl.dx, bbl.dy)
      ..close();
    canvas.drawPath(basePath, basePaint);

    // ── Front faces ──
    // Right face
    final rightGrad = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFE8A020).withOpacity(0.9),
          const Color(0xFF7A5000),
        ],
      ).createShader(Rect.fromPoints(apex, bfr))
      ..style = PaintingStyle.fill;

    final rightFace = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(bfr.dx, bfr.dy)
      ..lineTo(bbr.dx, bbr.dy)
      ..close();
    canvas.drawPath(rightFace, rightGrad);

    // Left face
    final leftGrad = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFD49018).withOpacity(0.7),
          const Color(0xFF4A3000),
        ],
      ).createShader(Rect.fromPoints(apex, bfl))
      ..style = PaintingStyle.fill;

    final leftFace = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(bfl.dx, bfl.dy)
      ..lineTo(bfr.dx, bfr.dy)
      ..close();
    canvas.drawPath(leftFace, leftGrad);

    // ── Edges ──
    final edgePaint = Paint()
      ..color = const Color(0xFFE8A020).withOpacity(0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Base edges
    canvas.drawLine(bfl, bfr, edgePaint);
    canvas.drawLine(bfr, bbr, edgePaint);
    canvas.drawLine(bbr, bbl, edgePaint);
    canvas.drawLine(bbl, bfl, edgePaint);

    // Lateral edges
    canvas.drawLine(apex, bfl, edgePaint);
    canvas.drawLine(apex, bfr, edgePaint);
    canvas.drawLine(apex, bbr, edgePaint);
    canvas.drawLine(apex, bbl, edgePaint);

    // ── Dimension lines ──
    _drawDimension(canvas, bfr, bbr, '${base.toStringAsFixed(1)}', false);
    _drawDimension(canvas, apex, bfr, '${height.toStringAsFixed(1)}', true);

    // ── Apex glow ──
    final glowPaint = Paint()
      ..color = const Color(0xFFE8A020).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(apex, 5, glowPaint);
    canvas.drawCircle(
        apex, 3, Paint()..color = const Color(0xFFFFD080));
  }

  void _drawDimension(
      Canvas canvas, Offset a, Offset b, String label, bool isHeight) {
    final dimPaint = Paint()
      ..color = const Color(0xFF555555)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final midX = (a.dx + b.dx) / 2;
    final midY = (a.dy + b.dy) / 2;
    final offset = isHeight ? const Offset(22, 0) : const Offset(0, 14);

    canvas.drawLine(
      Offset(a.dx + offset.dx, a.dy + offset.dy),
      Offset(b.dx + offset.dx, b.dy + offset.dy),
      dimPaint,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 10,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
        canvas, Offset(midX + offset.dx + 4, midY + offset.dy - 6));
  }

  @override
  bool shouldRepaint(PyramidPainter old) =>
      old.rotateAngle != rotateAngle ||
      old.scale != scale ||
      old.base != base ||
      old.height != height;
}