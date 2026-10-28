import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class OnboardingStepWelcomeWidget extends StatefulWidget {
  final String userName;
  final ValueChanged<String> onNameChanged;

  const OnboardingStepWelcomeWidget({
    super.key,
    required this.userName,
    required this.onNameChanged,
  });

  @override
  State<OnboardingStepWelcomeWidget> createState() =>
      _OnboardingStepWelcomeWidgetState();
}

class _OnboardingStepWelcomeWidgetState
    extends State<OnboardingStepWelcomeWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _controller.dispose();
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
            'Hello, friend 🌿',
            style: GoogleFonts.nunitoSans(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryDark,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Root is your gentle companion for burnout prevention.\nLet's start with your name.",
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.muted,
              height: 1.6,
            ),
          ),
          SizedBox(height: 36),
          Text(
            'What should we call you?',
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.muted,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _controller,
            onChanged: widget.onNameChanged,
            style: GoogleFonts.nunitoSans(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryDark,
            ),
            decoration: InputDecoration(
              hintText: 'Your name...',
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
            textCapitalization: TextCapitalization.words,
            autofocus: false,
          ),
          SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primary.withAlpha(38),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.eco_rounded, color: AppTheme.primary, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your personal garden awaits — every small action you take helps it grow.',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.primary.withAlpha(204),
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
