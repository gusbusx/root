import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../theme/app_theme.dart';

class HomeWaterWidget extends StatefulWidget {
  final int cupsLogged;
  final int cupsGoal;
  final VoidCallback onTap;
  final VoidCallback? onGoalEdit;

  const HomeWaterWidget({
    super.key,
    required this.cupsLogged,
    required this.cupsGoal,
    required this.onTap,
    this.onGoalEdit,
  });

  @override
  State<HomeWaterWidget> createState() => _HomeWaterWidgetState();
}

class _HomeWaterWidgetState extends State<HomeWaterWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fillController;
  late AnimationController _pourController;
  late AnimationController _rippleController;
  late Animation<double> _fillAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _pourAnimation;

  double _previousFill = 0;
  bool _showRipple = false;
  bool _showPour = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _previousFill = widget.cupsLogged / widget.cupsGoal;
    _fillAnimation = Tween<double>(begin: _previousFill, end: _previousFill)
        .animate(
          CurvedAnimation(parent: _fillController, curve: Curves.easeOutCubic),
        );

    _pourController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pourAnimation = CurvedAnimation(
      parent: _pourController,
      curve: Curves.easeInOut,
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _rippleAnimation = CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(HomeWaterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cupsLogged != widget.cupsLogged ||
        oldWidget.cupsGoal != widget.cupsGoal) {
      final newFill = widget.cupsLogged / widget.cupsGoal;
      _fillAnimation = Tween<double>(begin: _previousFill, end: newFill)
          .animate(
            CurvedAnimation(
              parent: _fillController,
              curve: Curves.easeOutCubic,
            ),
          );
      _previousFill = newFill;
      _fillController
        ..reset()
        ..forward();

      setState(() {
        _showRipple = true;
        _showPour = true;
      });
      _pourController
        ..reset()
        ..forward().then((_) {
          if (mounted) setState(() => _showPour = false);
        });
      _rippleController
        ..reset()
        ..forward().then((_) {
          if (mounted) setState(() => _showRipple = false);
        });
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fillController.dispose();
    _pourController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final isGoalMet = widget.cupsLogged >= widget.cupsGoal;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Pour animation above glass
          if (_showPour)
            AnimatedBuilder(
              animation: _pourAnimation,
              builder: (context, _) {
                return Opacity(
                  opacity: (1 - _pourAnimation.value).clamp(0.0, 1.0),
                  child: Container(
                    height: 30,
                    width: 4,
                    margin: const EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: AppTheme.waterBlue.withAlpha(180),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
          // Glass container
          GestureDetector(
            onTap: isGoalMet ? null : _handleTap,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _waveController,
                _fillAnimation,
                _rippleAnimation,
              ]),
              builder: (context, _) {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isGoalMet
                          ? AppTheme.primary.withAlpha(102)
                          : AppTheme.cardBorder,
                      width: isGoalMet ? 2 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: Stack(
                      children: [
                        // Water fill
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: CustomPaint(
                            painter: _WaterGlassPainter(
                              fillLevel: _fillAnimation.value,
                              wavePhase: _waveController.value,
                              isGoalMet: isGoalMet,
                            ),
                            size: const Size(double.infinity, 200),
                          ),
                        ),
                        // Ripple on tap
                        if (_showRipple)
                          Positioned.fill(
                            child: Opacity(
                              opacity: (1 - _rippleAnimation.value) * 0.12,
                              child: Container(color: AppTheme.waterBlue),
                            ),
                          ),
                        // Glass shine effect
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            width: 6,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(120),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        // Cup count
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Text(
                                '${widget.cupsLogged} / ${widget.cupsGoal}',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: _fillAnimation.value > 0.4
                                      ? Colors.white
                                      : AppTheme.waterBlueDark,
                                ),
                              ),
                              Text(
                                'cups today',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: _fillAnimation.value > 0.4
                                      ? Colors.white.withAlpha(200)
                                      : AppTheme.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tap hint
                        if (!isGoalMet)
                          Positioned(
                            top: 14,
                            right: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(200),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.water_drop_rounded,
                                    size: 11,
                                    color: AppTheme.waterBlueDark,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'tap to fill',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.waterBlueDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (isGoalMet)
                          Positioned(
                            top: 14,
                            right: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withAlpha(220),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Goal met!',
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Goal edit row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Daily goal: ${widget.cupsGoal} cups',
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: widget.onGoalEdit,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.waterBlue.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Edit',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 11,
                      color: AppTheme.waterBlueDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaterGlassPainter extends CustomPainter {
  final double fillLevel;
  final double wavePhase;
  final bool isGoalMet;

  _WaterGlassPainter({
    required this.fillLevel,
    required this.wavePhase,
    required this.isGoalMet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (fillLevel <= 0) return;

    final waterColor = isGoalMet
        ? AppTheme.primary.withAlpha(200)
        : AppTheme.waterBlue.withAlpha(200);
    final waterColorLight = isGoalMet
        ? AppTheme.primaryLight.withAlpha(160)
        : AppTheme.waterBlue.withAlpha(160);

    final fillHeight = size.height * fillLevel;
    final waterTop = size.height - fillHeight;

    final path = Path();
    path.moveTo(0, waterTop);

    for (double x = 0; x <= size.width; x++) {
      final y =
          waterTop +
          math.sin((x / size.width * 2 * math.pi) + wavePhase * 2 * math.pi) *
              5 +
          math.sin(
                (x / size.width * 4 * math.pi) + wavePhase * 2 * math.pi * 1.3,
              ) *
              3;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [waterColorLight, waterColor],
      ).createShader(Rect.fromLTWH(0, waterTop, size.width, fillHeight));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WaterGlassPainter old) =>
      old.fillLevel != fillLevel ||
      old.wavePhase != wavePhase ||
      old.isGoalMet != isGoalMet;
}
