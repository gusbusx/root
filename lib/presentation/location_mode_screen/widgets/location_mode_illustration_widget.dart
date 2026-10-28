import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class LocationModeIllustrationWidget extends StatefulWidget {
  final String mode;
  final bool isTablet;

  const LocationModeIllustrationWidget({
    super.key,
    required this.mode,
    this.isTablet = false,
  });

  @override
  State<LocationModeIllustrationWidget> createState() =>
      _LocationModeIllustrationWidgetState();
}

class _LocationModeIllustrationWidgetState
    extends State<LocationModeIllustrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _ambientController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  Color get _skyTop {
    switch (widget.mode) {
      case 'focus':
        return const Color(0xFF2D4A35);
      case 'rest':
        return const Color(0xFF4A8FA8);
      default:
        return const Color(0xFF8B7355);
    }
  }

  Color get _skyBottom {
    switch (widget.mode) {
      case 'focus':
        return const Color(0xFF5C7A5C);
      case 'rest':
        return const Color(0xFF87CEEB);
      default:
        return const Color(0xFFC4A882);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.isTablet
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 0.38;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          // Background gradient sky
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_skyTop, _skyBottom],
                ),
              ),
            ),
          ),
          // Mode-specific animated elements
          AnimatedBuilder(
            animation: Listenable.merge([
              _ambientController,
              _particleController,
            ]),
            builder: (context, _) {
              return CustomPaint(
                size: Size(double.infinity, height),
                painter: _ModeScenePainter(
                  mode: widget.mode,
                  ambientValue: _ambientController.value,
                  particleValue: _particleController.value,
                ),
              );
            },
          ),
          // Mode label overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withAlpha(64)],
                ),
              ),
              child: Row(children: [_ModeTag(mode: widget.mode)]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTag extends StatelessWidget {
  final String mode;
  const _ModeTag({required this.mode});

  String get _label {
    switch (mode) {
      case 'focus':
        return '🌿 Focus Mode';
      case 'rest':
        return '☀️ Rest Mode';
      default:
        return '🏡 Home Mode';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(77), width: 1),
      ),
      child: Text(
        _label,
        style: GoogleFonts.nunitoSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _ModeScenePainter extends CustomPainter {
  final String mode;
  final double ambientValue;
  final double particleValue;

  _ModeScenePainter({
    required this.mode,
    required this.ambientValue,
    required this.particleValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (mode) {
      case 'focus':
        _paintFocusScene(canvas, size);
        break;
      case 'rest':
        _paintRestScene(canvas, size);
        break;
      default:
        _paintHomeScene(canvas, size);
    }
  }

  void _paintFocusScene(Canvas canvas, Size size) {
    // Ground / forest floor
    final groundPaint = Paint()
      ..color = const Color(0xFF1E3A22)
      ..style = PaintingStyle.fill;
    final groundPath = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.68,
        size.width * 0.6,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.76,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(groundPath, groundPaint);

    // Tree trunks
    final trunkPaint = Paint()
      ..color = const Color(0xFF2A1F14).withAlpha(179)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width * 0.15, size.height),
      Offset(size.width * 0.15, size.height * 0.2),
      trunkPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.85, size.height),
      Offset(size.width * 0.85, size.height * 0.25),
      trunkPaint..strokeWidth = 14,
    );

    // Canopy blobs
    final canopyPaint = Paint()
      ..color = const Color(0xFF3D5A3E).withAlpha(217)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.15, size.height * 0.22),
        width: size.width * 0.35,
        height: size.height * 0.28,
      ),
      canopyPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.85, size.height * 0.28),
        width: size.width * 0.28,
        height: size.height * 0.24,
      ),
      canopyPaint..color = const Color(0xFF4A6B4A).withAlpha(191),
    );

    // Falling leaves
    final leafPaint = Paint()
      ..color = const Color(0xFF7AB87A).withAlpha(153)
      ..style = PaintingStyle.fill;

    final leafPositions = [
      Offset(size.width * 0.25, 0),
      Offset(size.width * 0.55, 0),
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.4, 0),
    ];

    for (int i = 0; i < leafPositions.length; i++) {
      final t = (particleValue + i * 0.25) % 1.0;
      final x = leafPositions[i].dx + math.sin(t * math.pi * 2 + i) * 30;
      final y = size.height * t;
      final rotation = t * math.pi * 4 + i;
      final opacity = math.sin(t * math.pi) * 0.7;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 10, height: 14),
        leafPaint..color = const Color(0xFF7AB87A).withOpacity(opacity),
      );
      canvas.restore();
    }

    // Soft mist / fog
    final mistPaint = Paint()
      ..color = Colors.white.withOpacity(0.06 + 0.04 * ambientValue)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.7),
        width: size.width * 1.2,
        height: size.height * 0.15,
      ),
      mistPaint,
    );
  }

  void _paintRestScene(Canvas canvas, Size size) {
    // Sun glow
    final sunGlowRadius = 60.0 + 12 * ambientValue;
    final sunCenter = Offset(size.width * 0.72, size.height * 0.22);

    // Outer glow rings
    for (int i = 3; i >= 0; i--) {
      final glowPaint = Paint()
        ..color = const Color(
          0xFFFFC947,
        ).withOpacity(0.06 - i * 0.01 + 0.02 * ambientValue)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(sunCenter, sunGlowRadius + i * 20, glowPaint);
    }

    // Sun core
    final sunPaint = Paint()
      ..color = const Color(0xFFFFC947).withAlpha(230)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(sunCenter, sunGlowRadius * 0.55, sunPaint);

    // Clouds
    final cloudPaint = Paint()
      ..color = Colors.white.withAlpha(191)
      ..style = PaintingStyle.fill;

    _drawCloud(
      canvas,
      Offset(size.width * 0.15 + 20 * ambientValue, size.height * 0.25),
      0.8,
      cloudPaint,
      size,
    );
    _drawCloud(
      canvas,
      Offset(size.width * 0.5 - 15 * ambientValue, size.height * 0.15),
      0.6,
      cloudPaint..color = Colors.white.withAlpha(140),
      size,
    );

    // Ground — bright grass
    final grassPaint = Paint()
      ..color = const Color(0xFF5A9A5A).withAlpha(230)
      ..style = PaintingStyle.fill;
    final grassPath = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.62,
        size.width * 0.7,
        size.height * 0.68,
      )
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 0.72,
        size.width,
        size.height * 0.65,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(grassPath, grassPaint);

    // Floating particles (dandelion seeds)
    final particlePaint = Paint()
      ..color = Colors.white.withAlpha(128)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      final t = (particleValue + i * 0.16) % 1.0;
      final x = size.width * (0.1 + i * 0.15) + math.sin(t * math.pi * 2) * 20;
      final y = size.height * (0.8 - t * 0.7);
      final opacity = math.sin(t * math.pi) * 0.6;
      final dotPaint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
      // Stem
      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + 8),
        particlePaint..color = Colors.white.withOpacity(opacity * 0.7),
      );
    }
  }

  void _paintHomeScene(Canvas canvas, Size size) {
    // Warm sky gradient already set via container

    // Rolling hills
    final hill1Paint = Paint()
      ..color = const Color(0xFF8B6F47).withAlpha(77)
      ..style = PaintingStyle.fill;
    final hill1 = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.42,
        size.width * 0.65,
        size.height * 0.55,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.63,
        size.width,
        size.height * 0.55,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill1, hill1Paint);

    final hill2Paint = Paint()
      ..color = const Color(0xFF6B4C2A).withAlpha(64)
      ..style = PaintingStyle.fill;
    final hill2 = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.62,
        size.width * 0.5,
        size.height * 0.7,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.78,
        size.width,
        size.height * 0.72,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill2, hill2Paint);

    // Cozy house silhouette
    final housePaint = Paint()
      ..color = const Color(0xFF5A3E28).withAlpha(140)
      ..style = PaintingStyle.fill;
    final hx = size.width * 0.42;
    final hy = size.height * 0.52;
    // Walls
    canvas.drawRect(
      Rect.fromLTWH(hx, hy, size.width * 0.18, size.height * 0.2),
      housePaint,
    );
    // Roof
    final roofPath = Path()
      ..moveTo(hx - size.width * 0.03, hy)
      ..lineTo(hx + size.width * 0.09, hy - size.height * 0.12)
      ..lineTo(hx + size.width * 0.21, hy)
      ..close();
    canvas.drawPath(
      roofPath,
      housePaint..color = const Color(0xFF3E2A18).withAlpha(153),
    );

    // Window warm glow
    final windowPaint = Paint()
      ..color = const Color(0xFFFFD580).withOpacity(0.5 + 0.2 * ambientValue)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          hx + size.width * 0.04,
          hy + size.height * 0.06,
          size.width * 0.04,
          size.height * 0.05,
        ),
        const Radius.circular(2),
      ),
      windowPaint,
    );

    // Stars / drifting dots
    final starPaint = Paint()
      ..color = Colors.white.withAlpha(153)
      ..style = PaintingStyle.fill;
    final starPositions = [
      Offset(size.width * 0.1, size.height * 0.1),
      Offset(size.width * 0.3, size.height * 0.06),
      Offset(size.width * 0.6, size.height * 0.08),
      Offset(size.width * 0.8, size.height * 0.12),
      Offset(size.width * 0.5, size.height * 0.18),
    ];
    for (int i = 0; i < starPositions.length; i++) {
      final twinkle =
          0.4 + 0.5 * math.sin(ambientValue * math.pi * 2 + i * 1.2);
      canvas.drawCircle(
        starPositions[i],
        1.8,
        starPaint..color = Colors.white.withOpacity(twinkle),
      );
    }
  }

  void _drawCloud(
    Canvas canvas,
    Offset center,
    double scale,
    Paint paint,
    Size size,
  ) {
    final r = 22.0 * scale;
    canvas.drawCircle(center, r, paint);
    canvas.drawCircle(
      Offset(center.dx + r * 1.1, center.dy + r * 0.2),
      r * 0.8,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx - r * 0.9, center.dy + r * 0.2),
      r * 0.7,
      paint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + r * 0.5),
        width: r * 2.8,
        height: r,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ModeScenePainter old) =>
      old.mode != mode ||
      old.ambientValue != ambientValue ||
      old.particleValue != particleValue;
}
