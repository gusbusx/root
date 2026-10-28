import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LocationManualCheckinWidget extends StatelessWidget {
  final List<Map<String, dynamic>> locationOptions;
  final String selectedLocation;
  final bool gpsEnabled;
  final void Function(String location, String mode) onLocationSelected;

  const LocationManualCheckinWidget({
    super.key,
    required this.locationOptions,
    required this.selectedLocation,
    required this.gpsEnabled,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              gpsEnabled ? 'Or check in manually' : 'Where are you right now?',
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C2C1E),
              ),
            ),
            if (!gpsEnabled) ...[
              SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withAlpha(31),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'required',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 6),
        Text(
          'Root adapts its mode and reminders based on your check-in.',
          style: GoogleFonts.nunitoSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppTheme.muted,
            height: 1.4,
          ),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
          children: locationOptions.map((option) {
            final isSelected = selectedLocation == option['label'];
            return _LocationChip(
              label: option['label'] as String,
              icon: option['icon'] as IconData,
              mode: option['mode'] as String,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                onLocationSelected(
                  option['label'] as String,
                  option['mode'] as String,
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 16),
        if (!gpsEnabled)
          _CheckInConfirmBanner(selectedLocation: selectedLocation),
      ],
    );
  }
}

class _LocationChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationChip({
    required this.label,
    required this.icon,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: _modeColor.withAlpha(26),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected ? _modeColor.withAlpha(26) : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _modeColor : AppTheme.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? _modeColor.withAlpha(38)
                    : AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? _modeColor : AppTheme.muted,
              ),
            ),
            SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? _modeColor : AppTheme.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckInConfirmBanner extends StatelessWidget {
  final String selectedLocation;
  const _CheckInConfirmBanner({required this.selectedLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withAlpha(51), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 18,
            color: AppTheme.primary,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Checked in at $selectedLocation — your mode and reminders are set.',
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
