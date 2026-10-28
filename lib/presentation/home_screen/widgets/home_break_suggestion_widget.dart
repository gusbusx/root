import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class HomeBreakSuggestionWidget extends StatefulWidget {
  final String mode;
  final bool isCompleted;
  final VoidCallback onComplete;

  const HomeBreakSuggestionWidget({
    super.key,
    required this.mode,
    required this.isCompleted,
    required this.onComplete,
  });

  @override
  State<HomeBreakSuggestionWidget> createState() =>
      _HomeBreakSuggestionWidgetState();
}

class _HomeBreakSuggestionWidgetState extends State<HomeBreakSuggestionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkController;
  late Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
    if (widget.isCompleted) _checkController.value = 1.0;
  }

  @override
  void didUpdateWidget(HomeBreakSuggestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isCompleted && widget.isCompleted) {
      _checkController.forward();
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getSuggestion() {
    if (widget.mode == 'focus') {
      return {
        'icon': Icons.air_rounded,
        'title': 'Box breathing — 4 minutes',
        'description':
            "You've been at your desk for a while. Try 4 counts in, 4 hold, 4 out. Just 4 rounds.",
        'color': AppTheme.focusModeTint,
        'points': 25,
        'cta': 'Start breathing',
      };
    } else if (widget.mode == 'rest') {
      return {
        'icon': Icons.directions_walk_rounded,
        'title': 'Mindful walk — 10 minutes',
        'description':
            "You're outside — this is the perfect time. Walk slowly, notice what's around you.",
        'color': AppTheme.restModeTint,
        'points': 30,
        'cta': 'Begin walk',
      };
    } else {
      return {
        'icon': Icons.self_improvement_rounded,
        'title': 'Gentle stretch — 5 minutes',
        'description':
            "Roll your shoulders, stretch your neck, breathe. Your body will thank you.",
        'color': AppTheme.homeModeTint,
        'points': 20,
        'cta': 'Start stretching',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = _getSuggestion();
    final Color accentColor = suggestion['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isCompleted
              ? AppTheme.primary.withAlpha(77)
              : accentColor.withAlpha(51),
          width: widget.isCompleted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(20),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(19),
                topRight: Radius.circular(19),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  suggestion['icon'] as IconData,
                  size: 16,
                  color: accentColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Break suggestion',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                    letterSpacing: 0.3,
                  ),
                ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(31),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${suggestion['points']} pts',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion['title'] as String,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  suggestion['description'] as String,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.muted,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 14),
                widget.isCompleted
                    ? ScaleTransition(
                        scale: _checkScale,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withAlpha(26),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primary.withAlpha(77),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 16,
                                color: AppTheme.primary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Break completed! +${suggestion['points']} pts earned',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onComplete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            suggestion['cta'] as String,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
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
