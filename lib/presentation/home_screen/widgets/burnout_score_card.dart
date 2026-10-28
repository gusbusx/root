import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/user_profile_service.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/location_theme.dart';

class BurnoutScoreCard extends StatefulWidget {
  final LocationThemeNotifier? themeNotifier;

  const BurnoutScoreCard({super.key, this.themeNotifier});

  @override
  State<BurnoutScoreCard> createState() => _BurnoutScoreCardState();
}

class _BurnoutScoreCardState extends State<BurnoutScoreCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scoreController;
  late Animation<double> _scoreAnim;
  final _service = UserProfileService();

  @override
  void initState() {
    super.initState();
    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnim = Tween<double>(begin: 0, end: _service.burnoutScore).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic),
    );
    _scoreController.forward();
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  Color get _tintColor =>
      widget.themeNotifier?.current.primaryColor ?? AppTheme.primary;

  @override
  Widget build(BuildContext context) {
    final score = _service.burnoutScore;
    final label = _service.burnoutLabel;
    final color = _service.burnoutColor;
    final prediction = _service.burnoutPrediction;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withAlpha(15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withAlpha(50), width: 1.5),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withAlpha(200), color.withAlpha(10)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Burnout Score',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.muted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AnimatedBuilder(
                              animation: _scoreAnim,
                              builder: (_, __) => Text(
                                _scoreAnim.value.toInt().toString(),
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                  height: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '/ 100',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 14,
                                  color: AppTheme.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _ScoreGauge(score: score, color: color),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(120),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withAlpha(30)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 14, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        prediction,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          color: AppTheme.primaryDark,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildScoreScale(score),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreScale(double score) {
    final zones = [
      {'label': 'Thriving', 'color': const Color(0xFF2D6A4F), 'max': 25.0},
      {'label': 'Balanced', 'color': const Color(0xFF5C7A5C), 'max': 50.0},
      {'label': 'Fatigued', 'color': const Color(0xFFC4774A), 'max': 70.0},
      {'label': 'Elevated', 'color': const Color(0xFFB85C3A), 'max': 85.0},
      {'label': 'Burnout', 'color': const Color(0xFF8B2020), 'max': 100.0},
    ];

    return Row(
      children: zones.map((z) {
        final isActive =
            score <= (z['max'] as double) &&
            (zones.indexOf(z) == 0 ||
                score > (zones[zones.indexOf(z) - 1]['max'] as double));
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: isActive
                  ? (z['color'] as Color)
                  : (z['color'] as Color).withAlpha(60),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ScoreGauge extends StatelessWidget {
  final double score;
  final Color color;

  const _ScoreGauge({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: CustomPaint(
        painter: _GaugePainter(score: score, color: color),
        child: Center(
          child: Icon(
            score <= 25
                ? Icons.eco_rounded
                : score <= 50
                ? Icons.spa_rounded
                : score <= 70
                ? Icons.warning_amber_rounded
                : Icons.priority_high_rounded,
            color: color,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final Color color;

  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final bgPaint = Paint()
      ..color = color.withAlpha(30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    const startAngle = -2.35;
    const sweepTotal = 4.71;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal,
      false,
      bgPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotal * (score / 100),
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.score != score;
}
