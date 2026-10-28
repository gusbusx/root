import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingStepOccupationWidget extends StatefulWidget {
  final String selectedOccupation;
  final ValueChanged<String> onOccupationSelected;

  const OnboardingStepOccupationWidget({
    super.key,
    required this.selectedOccupation,
    required this.onOccupationSelected,
  });

  @override
  State<OnboardingStepOccupationWidget> createState() =>
      _OnboardingStepOccupationWidgetState();
}

class _OnboardingStepOccupationWidgetState
    extends State<OnboardingStepOccupationWidget> {
  final TextEditingController _customController = TextEditingController();
  bool _showCustomField = false;

  static const List<Map<String, dynamic>> _occupations = [
    {'label': 'Student', 'emoji': '📚', 'desc': 'Studying & learning'},
    {'label': 'Professional', 'emoji': '💼', 'desc': 'Office or remote work'},
    {
      'label': 'Healthcare Worker',
      'emoji': '🏥',
      'desc': 'Medical & care roles',
    },
    {'label': 'Athlete', 'emoji': '🏃', 'desc': 'Sports & training'},
    {'label': 'Other', 'emoji': '✨', 'desc': 'Something else entirely'},
  ];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What do you do? 🌿',
            style: GoogleFonts.nunitoSans(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Root uses this to personalize your break suggestions, notification timing, and wellness benchmarks.',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.muted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          ...(_occupations.map((occ) {
            final isSelected = widget.selectedOccupation == occ['label'];
            return GestureDetector(
              onTap: () {
                widget.onOccupationSelected(occ['label'] as String);
                setState(() {
                  _showCustomField = occ['label'] == 'Other';
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary.withAlpha(20)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      occ['emoji'] as String,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            occ['label'] as String,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppTheme.primaryDark
                                  : const Color(0xFF2C2C1E),
                            ),
                          ),
                          Text(
                            occ['desc'] as String,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppTheme.primary
                            : Colors.transparent,
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
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          })),
          if (_showCustomField) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _customController,
              onChanged: (v) {
                if (v.isNotEmpty) widget.onOccupationSelected(v);
              },
              style: GoogleFonts.nunitoSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryDark,
              ),
              decoration: InputDecoration(
                hintText: 'Tell us what you do...',
                hintStyle: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  color: AppTheme.mutedLight,
                ),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
