import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingStepActivityWidget extends StatelessWidget {
  final bool playsSports;
  final String profileType;
  final ValueChanged<bool> onPlaysSportsChanged;

  const OnboardingStepActivityWidget({
    super.key,
    required this.playsSports,
    required this.profileType,
    required this.onPlaysSportsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Do you play sports or train regularly?',
            style: GoogleFonts.nunitoSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
              height: 1.3,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Athletes and active people need different recovery reminders — more rest, less hustle.',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.muted,
              height: 1.6,
            ),
          ),
          SizedBox(height: 32),
          _ActivityCard(
            emoji: '⚽',
            title: 'Yes, I train regularly',
            description:
                "Root will remind you to rest and recover — not just push through.",
            isSelected: playsSports,
            onTap: () => onPlaysSportsChanged(true),
          ),
          SizedBox(height: 14),
          _ActivityCard(
            emoji: '🧘',
            title: 'No, mostly light activity',
            description:
                "Root will focus on gentle movement breaks and stress reduction.",
            isSelected: !playsSports,
            onTap: () => onPlaysSportsChanged(false),
          ),
          SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withAlpha(18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.secondary.withAlpha(51),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Text('🌱', style: TextStyle(fontSize: 22)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You're all set!",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Your garden is ready to grow. Tap "Plant My Seed" to begin.',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.secondary.withAlpha(204),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withAlpha(18) : AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 28)),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primaryDark
                          : const Color(0xFF2C2C1E),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.muted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppTheme.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
