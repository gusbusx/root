import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../theme/app_theme.dart';

class HomeGardenWidget extends StatefulWidget {
  final int points;
  const HomeGardenWidget({super.key, required this.points});

  @override
  State<HomeGardenWidget> createState() => _HomeGardenWidgetState();
}

class _HomeGardenWidgetState extends State<HomeGardenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _swayController;

  @override
  void initState() {
    super.initState();
    _swayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _swayController.dispose();
    super.dispose();
  }

  int get _growthLevel {
    if (widget.points < 50) return 0;
    if (widget.points < 150) return 1;
    if (widget.points < 300) return 2;
    if (widget.points < 500) return 3;
    if (widget.points < 800) return 4;
    return 5;
  }

  String get _growthLabel {
    const labels = [
      'Seed',
      'Sprout',
      'Seedling',
      'Sapling',
      'Young Tree',
      'Thriving Tree',
    ];
    return labels[_growthLevel];
  }

  String get _growthEmoji {
    const emojis = ['🌰', '🌱', '🌿', '🪴', '🌳', '🌲'];
    return emojis[_growthLevel];
  }

  int get _nextLevelPoints {
    const thresholds = [50, 150, 300, 500, 800, 999999];
    return thresholds[_growthLevel];
  }

  @override
  Widget build(BuildContext context) {
    final progress = _growthLevel == 5
        ? 1.0
        : (widget.points -
                  [0, 50, 150, 300, 500, 800][_growthLevel].toDouble()) /
              (_nextLevelPoints -
                  [0, 50, 150, 300, 500, 800][_growthLevel].toDouble());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Your Garden',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryDark,
                ),
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.points} pts',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              // Garden illustration
              AnimatedBuilder(
                animation: _swayController,
                builder: (context, _) {
                  return CustomPaint(
                    size: const Size(100, 100),
                    painter: _GardenPainter(
                      growthLevel: _growthLevel,
                      swayValue: _swayController.value,
                    ),
                  );
                },
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _growthEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _growthLabel,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (_growthLevel < 5) ...[
                      Text(
                        '${_nextLevelPoints - widget.points} pts to next stage',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.muted,
                        ),
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: AppTheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primary,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ] else
                      Text(
                        'Fully thriving 🎉',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        _PointSource(
                          icon: Icons.water_drop_rounded,
                          label: 'Water',
                          color: AppTheme.waterBlue,
                        ),
                        SizedBox(width: 8),
                        _PointSource(
                          icon: Icons.self_improvement_rounded,
                          label: 'Breaks',
                          color: AppTheme.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PointSource extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _PointSource({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color.withAlpha(179)),
        SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppTheme.muted,
          ),
        ),
      ],
    );
  }
}

class _GardenPainter extends CustomPainter {
  final int growthLevel;
  final double swayValue;

  _GardenPainter({required this.growthLevel, required this.swayValue});

  @override
  void paint(Canvas canvas, Size size) {
    final groundPaint = Paint()
      ..color = AppTheme.secondary.withAlpha(38)
      ..style = PaintingStyle.fill;

    // Ground
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.88),
        width: size.width * 0.7,
        height: size.height * 0.12,
      ),
      groundPaint,
    );

    final stemPaint = Paint()
      ..color = AppTheme.primary.withAlpha(179)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final leafPaint = Paint()
      ..color = AppTheme.primary.withAlpha(204)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final groundY = size.height * 0.82;

    switch (growthLevel) {
      case 0:
        // Seed — just a dot
        canvas.drawCircle(
          Offset(cx, groundY),
          6,
          Paint()..color = AppTheme.secondary.withAlpha(153),
        );
        break;
      case 1:
        // Single sprout
        final sway = math.sin(swayValue * math.pi) * 3;
        canvas.drawLine(
          Offset(cx, groundY),
          Offset(cx + sway, groundY - 30),
          stemPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx + sway, groundY - 38),
            width: 12,
            height: 16,
          ),
          leafPaint,
        );
        break;
      case 2:
        // Two leaves
        final sway = math.sin(swayValue * math.pi) * 4;
        canvas.drawLine(
          Offset(cx, groundY),
          Offset(cx + sway, groundY - 45),
          stemPaint,
        );
        _drawLeaf(
          canvas,
          Offset(cx + sway - 10, groundY - 30),
          -0.4,
          leafPaint,
        );
        _drawLeaf(canvas, Offset(cx + sway + 10, groundY - 30), 0.4, leafPaint);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx + sway, groundY - 52),
            width: 14,
            height: 18,
          ),
          leafPaint,
        );
        break;
      case 3:
        // Sapling
        final sway = math.sin(swayValue * math.pi) * 3;
        canvas.drawLine(
          Offset(cx, groundY),
          Offset(cx + sway, groundY - 60),
          stemPaint..strokeWidth = 4,
        );
        for (int i = 0; i < 3; i++) {
          final y = groundY - 20 - i * 18.0;
          _drawLeaf(
            canvas,
            Offset(cx + sway - 14 + i * 7, y),
            -0.5 + i * 0.25,
            leafPaint,
          );
        }
        break;
      case 4:
      case 5:
        // Tree
        final sway = math.sin(swayValue * math.pi) * 2;
        final trunkPaint = Paint()
          ..color = AppTheme.homeModeTint.withAlpha(153)
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
        canvas.drawLine(
          Offset(cx, groundY),
          Offset(cx + sway, groundY - 55),
          trunkPaint,
        );
        final canopyPaint = Paint()
          ..color = AppTheme.primary.withOpacity(growthLevel == 5 ? 0.85 : 0.65)
          ..style = PaintingStyle.fill;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(cx + sway, groundY - 72),
            width: 52,
            height: 44,
          ),
          canopyPaint,
        );
        if (growthLevel == 5) {
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(cx + sway - 18, groundY - 60),
              width: 28,
              height: 22,
            ),
            canopyPaint,
          );
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(cx + sway + 18, groundY - 60),
              width: 28,
              height: 22,
            ),
            canopyPaint,
          );
        }
        break;
    }
  }

  void _drawLeaf(Canvas canvas, Offset center, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 10, height: 16),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GardenPainter old) =>
      old.growthLevel != growthLevel || old.swayValue != swayValue;
}
