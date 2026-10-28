import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/user_profile_service.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/location_theme.dart';

class DailyCheckInCard extends StatefulWidget {
  final VoidCallback onComplete;
  final LocationThemeNotifier? themeNotifier;

  const DailyCheckInCard({
    super.key,
    required this.onComplete,
    this.themeNotifier,
  });

  @override
  State<DailyCheckInCard> createState() => _DailyCheckInCardState();
}

class _DailyCheckInCardState extends State<DailyCheckInCard>
    with SingleTickerProviderStateMixin {
  double _sleepQuality = 3.0;
  String _mood = '';
  bool? _didRestful;
  int _step = 0;

  late AnimationController _slideController;
  late Animation<Offset> _slideOut;
  late Animation<double> _fadeOut;

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Energized', 'emoji': '⚡', 'color': Color(0xFFC4A030)},
    {'label': 'Okay', 'emoji': '🌿', 'color': Color(0xFF5C7A5C)},
    {'label': 'Tired', 'emoji': '😴', 'color': Color(0xFF7A8A9A)},
    {'label': 'Stressed', 'emoji': '🌊', 'color': Color(0xFFC4774A)},
    {'label': 'Anxious', 'emoji': '🍂', 'color': Color(0xFFB85C3A)},
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideOut = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.5))
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeInCubic),
        );
    _fadeOut = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    HapticFeedback.mediumImpact();
    final checkIn = DailyCheckIn(
      date: DateTime.now(),
      sleepQuality: _sleepQuality,
      mood: _mood.isEmpty ? 'Okay' : _mood,
      didRestfulActivity: _didRestful ?? false,
      completed: true,
    );
    await UserProfileService().completeCheckIn(checkIn);
    await _slideController.forward();
    widget.onComplete();
  }

  Color get _themeColor =>
      widget.themeNotifier?.current.primaryColor ?? AppTheme.primary;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideOut,
      child: FadeTransition(
        opacity: _fadeOut,
        child: Scaffold(
          backgroundColor: Colors.black.withAlpha(180),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(230),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: _themeColor.withAlpha(40),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 28),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _buildStep(),
                        ),
                        const SizedBox(height: 24),
                        _buildActions(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _step == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _step == i ? _themeColor : _themeColor.withAlpha(60),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _step == 0
              ? 'Good morning 🌅'
              : _step == 1
              ? 'How are you feeling?'
              : 'One last thing...',
          style: GoogleFonts.nunitoSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          _step == 0
              ? 'How did you sleep last night?'
              : _step == 1
              ? 'Pick the one that feels most true right now.'
              : 'Did you do anything restful yesterday?',
          style: GoogleFonts.nunitoSans(
            fontSize: 13,
            color: AppTheme.muted,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildSleepStep();
      case 1:
        return _buildMoodStep();
      case 2:
        return _buildRestfulStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildSleepStep() {
    final labels = ['Very poor', 'Poor', 'Okay', 'Good', 'Great'];
    final emojis = ['😫', '😔', '😐', '😊', '😄'];
    final idx = (_sleepQuality - 1).round().clamp(0, 4);
    return Column(
      key: const ValueKey('sleep'),
      children: [
        Text(emojis[idx], style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 8),
        Text(
          labels[idx],
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _themeColor,
          ),
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: _themeColor,
            inactiveTrackColor: _themeColor.withAlpha(40),
            thumbColor: _themeColor,
            overlayColor: _themeColor.withAlpha(30),
            trackHeight: 6,
          ),
          child: Slider(
            value: _sleepQuality,
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: (v) => setState(() => _sleepQuality = v),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodStep() {
    return Wrap(
      key: const ValueKey('mood'),
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: _moods.map((m) {
        final isSelected = _mood == m['label'];
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _mood = m['label'] as String);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? (m['color'] as Color).withAlpha(30)
                  : AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? (m['color'] as Color) : AppTheme.cardBorder,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  m['emoji'] as String,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  m['label'] as String,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? (m['color'] as Color)
                        : AppTheme.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRestfulStep() {
    return Row(
      key: const ValueKey('restful'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _YesNoButton(
          label: 'Yes',
          emoji: '🌿',
          isSelected: _didRestful == true,
          color: AppTheme.primary,
          onTap: () => setState(() => _didRestful = true),
        ),
        const SizedBox(width: 16),
        _YesNoButton(
          label: 'Not really',
          emoji: '🌱',
          isSelected: _didRestful == false,
          color: AppTheme.muted,
          onTap: () => setState(() => _didRestful = false),
        ),
      ],
    );
  }

  Widget _buildActions() {
    final isLastStep = _step == 2;
    final canProceed = _step == 0
        ? true
        : _step == 1
        ? _mood.isNotEmpty
        : _didRestful != null;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canProceed
                ? () {
                    if (isLastStep) {
                      _complete();
                    } else {
                      setState(() => _step++);
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _themeColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              isLastStep ? 'Start my day ✨' : 'Next',
              style: GoogleFonts.nunitoSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (!isLastStep) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              if (isLastStep) {
                _complete();
              } else {
                setState(() => _step++);
              }
            },
            child: Text(
              'Skip',
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                color: AppTheme.muted,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _YesNoButton extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _YesNoButton({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(20) : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppTheme.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : AppTheme.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
