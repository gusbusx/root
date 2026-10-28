import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: AppTheme.primary.withAlpha(153)),
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.nunitoSans(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppTheme.muted,
            ),
            textAlign: TextAlign.center,
          ),
          if (ctaLabel != null && onCta != null) ...[
            SizedBox(height: 24),
            ElevatedButton(onPressed: onCta, child: Text(ctaLabel!)),
          ],
        ],
      ),
    );
  }
}
