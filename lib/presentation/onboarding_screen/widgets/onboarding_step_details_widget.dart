import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingStepDetailsWidget extends StatefulWidget {
  final int age;
  final bool inSchool;
  final ValueChanged<int> onAgeChanged;
  final ValueChanged<bool> onInSchoolChanged;

  const OnboardingStepDetailsWidget({
    super.key,
    required this.age,
    required this.inSchool,
    required this.onAgeChanged,
    required this.onInSchoolChanged,
  });

  @override
  State<OnboardingStepDetailsWidget> createState() =>
      _OnboardingStepDetailsWidgetState();
}

class _OnboardingStepDetailsWidgetState
    extends State<OnboardingStepDetailsWidget> {
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(
      text: widget.age > 0 ? widget.age.toString() : '',
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
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
            'A little about you',
            style: GoogleFonts.nunitoSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Root uses this to personalise your experience — nothing is shared.',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.muted,
              height: 1.6,
            ),
          ),
          SizedBox(height: 36),
          Text(
            'Your age',
            style: GoogleFonts.nunitoSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.muted,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) {
              final parsed = int.tryParse(v) ?? 0;
              widget.onAgeChanged(parsed);
            },
            style: GoogleFonts.nunitoSans(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryDark,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. 24',
              hintStyle: GoogleFonts.nunitoSans(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: AppTheme.mutedLight,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.cardBorder, width: 1.5),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.cardBorder, width: 1.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.primary, width: 2),
              ),
            ),
          ),
          SizedBox(height: 36),
          Text(
            'Are you currently enrolled in school or university?',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2C2C1E),
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _ToggleOption(
                label: 'Yes',
                isSelected: widget.inSchool,
                onTap: () => widget.onInSchoolChanged(true),
              ),
              SizedBox(width: 12),
              _ToggleOption(
                label: 'No',
                isSelected: !widget.inSchool,
                onTap: () => widget.onInSchoolChanged(false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withAlpha(26)
                : AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.primary : AppTheme.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
