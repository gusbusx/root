import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LocationModeInfoWidget extends StatelessWidget {
  final String mode;
  final String location;

  const LocationModeInfoWidget({
    super.key,
    required this.mode,
    required this.location,
  });

  Map<String, String> get _modeContent {
    switch (mode) {
      case 'focus':
        return {
          'title': 'Focus Mode',
          'subtitle': 'Calm desk energy — deep work, gentle pacing.',
          'description':
              'Root has shifted into a quieter rhythm. You\'ll get timed reminders to breathe, stretch, and step away from your screen. No guilt, just gentle nudges.',
          'reminder': '⏰ Next reminder in ~45 min',
        };
      case 'rest':
        return {
          'title': 'Rest Mode',
          'subtitle': 'Open sky — movement, air, recovery.',
          'description':
              'You\'re in a restorative space. Root will encourage you to move freely, notice your surroundings, and let your mind wander. Recovery is productive.',
          'reminder': '🌿 Enjoy — no reminders for 30 min',
        };
      default:
        return {
          'title': 'Home Mode',
          'subtitle': 'Warm and grounded — wind down.',
          'description':
              'You\'re home. Root shifts to evening wind-down mode — hydration reminders, light stretching, and a gentle prompt to prepare for rest.',
          'reminder': '🌙 Wind-down routine starts at 9 PM',
        };
    }
  }

  Color get _accentColor {
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
    final content = _modeContent;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content['title']!,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _accentColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      content['subtitle']!,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _accentColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _accentColor.withAlpha(64),
                    width: 1,
                  ),
                ),
                child: Text(
                  location,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _accentColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            content['description']!,
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF5A5A4A),
              height: 1.6,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: _accentColor.withAlpha(18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accentColor.withAlpha(38), width: 1),
            ),
            child: Text(
              content['reminder']!,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
