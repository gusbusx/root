import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class HomeStatsRowWidget extends StatelessWidget {
  final int points;
  final int streakDays;
  final int waterCups;
  final int waterGoal;

  const HomeStatsRowWidget({
    super.key,
    required this.points,
    required this.streakDays,
    required this.waterCups,
    required this.waterGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _StatChip(
              icon: Icons.local_fire_department_rounded,
              value: '$streakDays',
              label: 'day streak',
              color: AppTheme.secondary,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _StatChip(
              icon: Icons.eco_rounded,
              value: '$points',
              label: 'garden pts',
              color: AppTheme.primary,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _StatChip(
              icon: Icons.water_drop_rounded,
              value: '$waterCups/$waterGoal',
              label: 'cups today',
              color: AppTheme.waterBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(51), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppTheme.muted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
