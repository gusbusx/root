import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/user_profile_service.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/location_theme.dart';

class EnergyMultiplierBar extends StatefulWidget {
  final LocationThemeNotifier? themeNotifier;

  const EnergyMultiplierBar({super.key, this.themeNotifier});

  @override
  State<EnergyMultiplierBar> createState() => _EnergyMultiplierBarState();
}

class _EnergyMultiplierBarState extends State<EnergyMultiplierBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _fillController;
  late Animation<double> _fillAnim;
  final _service = UserProfileService();

  @override
  void initState() {
    super.initState();
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fillAnim = Tween<double>(begin: 0, end: _service.energyMultiplierProgress)
        .animate(
          CurvedAnimation(parent: _fillController, curve: Curves.easeOutCubic),
        );
    _fillController.forward();
  }

  @override
  void dispose() {
    _fillController.dispose();
    super.dispose();
  }

  Color get _tintColor =>
      widget.themeNotifier?.current.primaryColor ?? AppTheme.primary;

  @override
  Widget build(BuildContext context) {
    final multiplier = _service.multiplier;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(180),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _tintColor.withAlpha(30), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Your energy today',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _tintColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${multiplier.toStringAsFixed(1)}x',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _tintColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _fillAnim,
                builder: (_, __) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4B896),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _fillAnim.value.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF8B6F47),
                                const Color(0xFF5C7A5C),
                                const Color(0xFF3A6A3A),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildMultiplierHints(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultiplierHints() {
    final hints = _getActiveHints();
    if (hints.isEmpty) {
      return Text(
        'Complete healthy habits to fill your energy bar',
        style: GoogleFonts.nunitoSans(fontSize: 11, color: AppTheme.muted),
      );
    }
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: hints
          .map(
            (h) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                h,
                style: GoogleFonts.nunitoSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primary,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  List<String> _getActiveHints() {
    final hints = <String>[];
    if (_service.sleepStreakDays >= 3) hints.add('💤 Sleep streak 1.5x');
    if (_service.waterCups >= _service.waterGoal) {
      hints.add('💧 Water goal 1.2x');
    }
    if (_service.meditationSessionsThisWeek > 0) {
      hints.add('🧘 Meditation 1.2x');
    }
    return hints;
  }
}
