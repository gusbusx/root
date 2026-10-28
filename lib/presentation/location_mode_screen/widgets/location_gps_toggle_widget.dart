import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LocationGpsToggleWidget extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final ValueChanged<bool> onToggle;

  const LocationGpsToggleWidget({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isEnabled
              ? AppTheme.primary.withAlpha(77)
              : AppTheme.cardBorder,
          width: isEnabled ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppTheme.primary.withAlpha(26)
                  : AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isEnabled ? Icons.gps_fixed_rounded : Icons.gps_off_rounded,
              size: 22,
              color: isEnabled ? AppTheme.primary : AppTheme.muted,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automatic location',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C2C1E),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  isEnabled
                      ? 'Root detects your location and shifts mode automatically.'
                      : 'Enable to let Root adapt to where you are.',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.muted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          isLoading
              ? SizedBox(
                  width: 32,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onToggle(!isEnabled);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    width: 48,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isEnabled ? AppTheme.primary : AppTheme.cardBorder,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      alignment: isEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
