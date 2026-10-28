import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_routes.dart';

class HomeModeBadgeWidget extends StatelessWidget {
  final String mode;
  const HomeModeBadgeWidget({super.key, required this.mode});

  Color get _modeColor {
    switch (mode) {
      case 'focus':
        return AppTheme.focusModeTint;
      case 'rest':
        return AppTheme.restModeTint;
      default:
        return AppTheme.homeModeTint;
    }
  }

  IconData get _modeIcon {
    switch (mode) {
      case 'focus':
        return Icons.self_improvement_rounded;
      case 'rest':
        return Icons.wb_sunny_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  String get _modeLabel {
    switch (mode) {
      case 'focus':
        return 'Focus Mode';
      case 'rest':
        return 'Rest Mode';
      default:
        return 'Home Mode';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.locationModeScreen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: _modeColor.withAlpha(26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _modeColor.withAlpha(64), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_modeIcon, size: 14, color: _modeColor),
            SizedBox(width: 6),
            Text(
              _modeLabel,
              style: GoogleFonts.nunitoSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _modeColor,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 14,
              color: _modeColor.withAlpha(153),
            ),
          ],
        ),
      ),
    );
  }
}
