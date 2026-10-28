import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/user_profile_service.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/location_theme.dart';

class LocationStatusChip extends StatefulWidget {
  final String currentLocation;
  final int minutesAtLocation;
  final LocationThemeNotifier? themeNotifier;
  final VoidCallback? onTap;

  const LocationStatusChip({
    super.key,
    required this.currentLocation,
    required this.minutesAtLocation,
    this.themeNotifier,
    this.onTap,
  });

  @override
  State<LocationStatusChip> createState() => _LocationStatusChipState();
}

class _LocationStatusChipState extends State<LocationStatusChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color get _tintColor =>
      widget.themeNotifier?.current.primaryColor ?? AppTheme.primary;

  String _formatTime(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _tintColor.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _tintColor.withAlpha(50), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, __) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _tintColor.withAlpha((_pulse.value * 255).toInt()),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'At ${widget.currentLocation}',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _tintColor,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '— ${_formatTime(widget.minutesAtLocation)}',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: _tintColor.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ManualHourlyTimeline extends StatelessWidget {
  final LocationThemeNotifier? themeNotifier;

  const ManualHourlyTimeline({super.key, this.themeNotifier});

  static const Map<String, Color> _locationColors = {
    'Work': Color(0xFF5A5A4A),
    'School': Color(0xFF5A7A3A),
    'Park': Color(0xFF3A6A3A),
    'Home': Color(0xFFC4774A),
    'Gym': Color(0xFF2A6A7A),
    'Other': Color(0xFF5C7A5C),
  };

  Color _colorForLocation(String loc) =>
      _locationColors[loc] ?? AppTheme.primary;

  @override
  Widget build(BuildContext context) {
    final service = UserProfileService();
    final logs = service.todayLocationLogs;

    if (logs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.timeline_rounded, size: 16, color: AppTheme.muted),
            const SizedBox(width: 8),
            Text(
              'No location logs yet today',
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                color: AppTheme.muted,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s journey',
          style: GoogleFonts.nunitoSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.muted,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: Row(
            children: logs.map((log) {
              final color = _colorForLocation(log.location);
              return Expanded(
                child: Tooltip(
                  message: '${log.location} (${log.minutesSpent}m)',
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: logs.length <= 6
                        ? Center(
                            child: Text(
                              log.location.substring(0, 1),
                              style: GoogleFonts.nunitoSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: _locationColors.entries
              .take(4)
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: e.value,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        e.key,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 9,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
