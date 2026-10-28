import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../theme/app_theme.dart';

class OnboardingHeaderWidget extends StatefulWidget {
  final int currentStep;
  const OnboardingHeaderWidget({super.key, required this.currentStep});

  @override
  State<OnboardingHeaderWidget> createState() => _OnboardingHeaderWidgetState();
}

class _OnboardingHeaderWidgetState extends State<OnboardingHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _leafController;

  @override
  void initState() {
    super.initState();
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _leafController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary.withAlpha(38),
            AppTheme.secondary.withAlpha(20),
            AppTheme.waterBlue.withAlpha(15),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // Background landscape painter
          Positioned.fill(child: CustomPaint(painter: _LandscapePainter())),
          // Animated floating leaves
          AnimatedBuilder(
            animation: _leafController,
            builder: (context, _) {
              return Stack(
                children: [
                  _FloatingLeaf(
                    animation: _leafController,
                    offset: const Offset(60, 40),
                    delay: 0.0,
                    size: 18,
                  ),
                  _FloatingLeaf(
                    animation: _leafController,
                    offset: const Offset(200, 60),
                    delay: 0.3,
                    size: 14,
                  ),
                  _FloatingLeaf(
                    animation: _leafController,
                    offset: const Offset(300, 30),
                    delay: 0.6,
                    size: 20,
                  ),
                ],
              );
            },
          ),
          // App name + tagline
          Positioned(
            bottom: 24,
            left: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'root',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'grow at your own pace',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.primary.withAlpha(204),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingLeaf extends StatelessWidget {
  final AnimationController animation;
  final Offset offset;
  final double delay;
  final double size;

  const _FloatingLeaf({
    required this.animation,
    required this.offset,
    required this.delay,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = (animation.value + delay) % 1.0;
        final sway = math.sin(t * math.pi * 2) * 8;
        final verticalDrift = math.sin(t * math.pi) * 12;
        final rotation = math.sin(t * math.pi * 2) * 0.3;
        return Positioned(
          left: offset.dx + sway,
          top: offset.dy + verticalDrift,
          child: Transform.rotate(
            angle: rotation,
            child: Opacity(
              opacity: 0.5 + 0.3 * math.sin(t * math.pi),
              child: Icon(
                Icons.eco_rounded,
                size: size,
                color: AppTheme.primary.withAlpha(153),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final hillPaint = Paint()
      ..color = AppTheme.primary.withAlpha(20)
      ..style = PaintingStyle.fill;

    final hill2Paint = Paint()
      ..color = AppTheme.secondary.withAlpha(15)
      ..style = PaintingStyle.fill;

    // Background hill
    final hill1 = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.3,
        size.width * 0.6,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.75,
        size.width,
        size.height * 0.65,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill1, hillPaint);

    // Foreground hill
    final hill2 = Path()
      ..moveTo(0, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.6,
        size.width * 0.5,
        size.height * 0.75,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.9,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill2, hill2Paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
