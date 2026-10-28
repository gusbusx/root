import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum WellnessStatus { focus, rest, home, water, streak, points }

class StatusBadgeWidget extends StatelessWidget {
  final WellnessStatus status;
  final String label;
  final bool compact;

  const StatusBadgeWidget({
    super.key,
    required this.status,
    required this.label,
    this.compact = false,
  });

  Color _bgColor() {
    switch (status) {
      case WellnessStatus.focus:
        return AppTheme.focusModeTint.withAlpha(31);
      case WellnessStatus.rest:
        return AppTheme.restModeTint.withAlpha(31);
      case WellnessStatus.home:
        return AppTheme.homeModeTint.withAlpha(31);
      case WellnessStatus.water:
        return AppTheme.waterBlue.withAlpha(31);
      case WellnessStatus.streak:
        return AppTheme.secondary.withAlpha(31);
      case WellnessStatus.points:
        return AppTheme.primary.withAlpha(31);
    }
  }

  Color _textColor() {
    switch (status) {
      case WellnessStatus.focus:
        return AppTheme.focusModeTint;
      case WellnessStatus.rest:
        return AppTheme.restModeTint;
      case WellnessStatus.home:
        return AppTheme.homeModeTint;
      case WellnessStatus.water:
        return AppTheme.waterBlueDark;
      case WellnessStatus.streak:
        return AppTheme.secondary;
      case WellnessStatus.points:
        return AppTheme.primary;
    }
  }

  IconData _icon() {
    switch (status) {
      case WellnessStatus.focus:
        return Icons.self_improvement_rounded;
      case WellnessStatus.rest:
        return Icons.wb_sunny_rounded;
      case WellnessStatus.home:
        return Icons.home_rounded;
      case WellnessStatus.water:
        return Icons.water_drop_rounded;
      case WellnessStatus.streak:
        return Icons.local_fire_department_rounded;
      case WellnessStatus.points:
        return Icons.eco_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _textColor().withAlpha(64), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon(), size: compact ? 12 : 14, color: _textColor()),
          SizedBox(width: compact ? 4 : 6),
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: _textColor(),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
