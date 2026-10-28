import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingStepProfileWidget extends StatelessWidget {
  final String selectedProfile;
  final ValueChanged<String> onProfileSelected;

  const OnboardingStepProfileWidget({
    super.key,
    required this.selectedProfile,
    required this.onProfileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Who are you right now?',
            style: GoogleFonts.nunitoSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'This helps Root time your reminders around your actual life.',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.muted,
              height: 1.6,
            ),
          ),
          SizedBox(height: 32),
          _ProfileCard(
            type: 'student',
            emoji: '📚',
            title: 'Student',
            description:
                'Class schedules, study sessions, campus life. Reminders adapt around your academic day.',
            isSelected: selectedProfile == 'student',
            onTap: () => onProfileSelected('student'),
          ),
          SizedBox(height: 16),
          _ProfileCard(
            type: 'professional',
            emoji: '💼',
            title: 'Professional',
            description:
                'Work meetings, deadlines, office hours. Reminders adapt around your 9–5 rhythm.',
            isSelected: selectedProfile == 'professional',
            onTap: () => onProfileSelected('professional'),
          ),
          SizedBox(height: 16),
          Text(
            'You can always change this in settings.',
            style: GoogleFonts.nunitoSans(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppTheme.mutedLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String type;
  final String emoji;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.type,
    required this.emoji,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primary.withAlpha(18) : AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: AppTheme.primary.withAlpha(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary.withAlpha(31)
                      : AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 26)),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
