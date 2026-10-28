import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingStepHealthWidget extends StatelessWidget {
  final List<String> selectedConditions;
  final ValueChanged<List<String>> onConditionsChanged;

  const OnboardingStepHealthWidget({
    super.key,
    required this.selectedConditions,
    required this.onConditionsChanged,
  });

  static const List<Map<String, dynamic>> _conditions = [
    {
      'id': 'diabetes_t1',
      'emoji': '🩸',
      'label': 'Diabetes (Type 1)',
      'hint': 'Blood sugar reminders, hydration alerts',
    },
    {
      'id': 'diabetes_t2',
      'emoji': '🩸',
      'label': 'Diabetes (Type 2)',
      'hint': 'Movement prompts after meals, hydration',
    },
    {
      'id': 'cholesterol',
      'emoji': '💛',
      'label': 'High Cholesterol',
      'hint': 'Gentle movement reminders, breathing exercises',
    },
    {
      'id': 'hypertension',
      'emoji': '💙',
      'label': 'High Blood Pressure',
      'hint': 'Stress-reduction focus, calming content',
    },
    {
      'id': 'anxiety',
      'emoji': '🌿',
      'label': 'Anxiety / Chronic Stress',
      'hint': 'Softer notifications, breathing exercises',
    },
    {
      'id': 'heart',
      'emoji': '❤️',
      'label': 'Heart Condition',
      'hint': 'Gentle movement, meditation nudges',
    },
    {
      'id': 'other',
      'emoji': '✨',
      'label': 'Other',
      'hint': 'We\'ll keep your wellness gentle and personal',
    },
  ];

  void _toggle(String id) {
    final updated = List<String>.from(selectedConditions);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    onConditionsChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Help Root take better\ncare of you',
            style: GoogleFonts.nunitoSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Sharing health conditions is completely optional. Root uses this to personalize your reminders and break suggestions — never to judge.',
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppTheme.muted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          ..._conditions.map((c) {
            final isSelected = selectedConditions.contains(c['id'] as String);
            return _ConditionCard(
              emoji: c['emoji'] as String,
              label: c['label'] as String,
              hint: c['hint'] as String,
              isSelected: isSelected,
              onTap: () => _toggle(c['id'] as String),
            );
          }),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primary.withAlpha(40)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🔒', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Your health information stays on your device and is never shared.',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 11,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
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

class _ConditionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String hint;
  final bool isSelected;
  final VoidCallback onTap;

  const _ConditionCard({
    required this.emoji,
    required this.label,
    required this.hint,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withAlpha(18) : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppTheme.primary.withAlpha(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppTheme.primaryDark
                              : const Color(0xFF2C2C1E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hint,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 11,
                          color: AppTheme.muted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppTheme.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.cardBorder,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
