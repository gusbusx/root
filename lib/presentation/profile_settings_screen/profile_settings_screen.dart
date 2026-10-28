import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/user_profile_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/location_theme.dart';
import '../../widgets/app_navigation.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final LocationThemeNotifier? themeNotifier;

  const ProfileSettingsScreen({super.key, this.themeNotifier});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _service = UserProfileService();
  bool _healthKitSyncing = false;
  DateTime? _lastSyncTime;

  Color get _themeColor =>
      widget.themeNotifier?.current.primaryColor ?? AppTheme.primary;

  Color get _bgColor =>
      widget.themeNotifier?.current.backgroundColor ?? AppTheme.background;

  @override
  Widget build(BuildContext context) {
    final profile = _service.profile;

    return Scaffold(
      backgroundColor: _bgColor,
      bottomNavigationBar: AppNavigation(
        currentIndex: 4,
        themeNotifier: widget.themeNotifier,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _themeColor.withAlpha(15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 20,
                          color: _themeColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Profile & Settings',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            // Profile card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildProfileCard(profile),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Apple Watch / HealthKit sync
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildHealthKitCard(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Health conditions
            if (profile != null && profile.healthConditions.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildHealthConditionsCard(profile),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Location tracking mode
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildLocationTrackingCard(profile),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserProfile? profile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(200),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _themeColor.withAlpha(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _themeColor.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        profile?.firstName.isNotEmpty == true
                            ? profile!.firstName[0].toUpperCase()
                            : '🌿',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: _themeColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile?.firstName ?? 'Friend',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        if (profile != null) ...[
                          Text(
                            '${profile.occupation} · Age ${profile.age}',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (profile != null) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _ProfileChip(
                      label: profile.profileType,
                      color: _themeColor,
                    ),
                    const SizedBox(width: 8),
                    if (profile.playsSports)
                      _ProfileChip(
                        label: 'Athlete 🏃',
                        color: AppTheme.secondary,
                      ),
                    if (profile.inSchool)
                      _ProfileChip(
                        label: 'In School 📚',
                        color: AppTheme.primary,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthKitCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(200),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _themeColor.withAlpha(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3B30).withAlpha(15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('⌚', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apple Watch & HealthKit',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        Text(
                          _lastSyncTime != null
                              ? 'Last synced: ${_formatSyncTime(_lastSyncTime!)}'
                              : 'Not yet synced',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 11,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSyncStatusBadge(),
                ],
              ),
              const SizedBox(height: 16),
              _buildHealthDataRow('😴', 'Sleep', '7.2h avg', 'Last 7 nights'),
              const SizedBox(height: 10),
              _buildHealthDataRow('❤️', 'Heart Rate', '68 bpm', 'Resting avg'),
              const SizedBox(height: 10),
              _buildHealthDataRow(
                '💧',
                'Water',
                'Synced',
                'With in-app tracker',
              ),
              const SizedBox(height: 10),
              _buildHealthDataRow('📱', 'Screen Time', '4.2h', 'Daily avg'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _triggerSync,
                  icon: _healthKitSyncing
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _themeColor,
                          ),
                        )
                      : Icon(Icons.sync_rounded, size: 16, color: _themeColor),
                  label: Text(
                    _healthKitSyncing ? 'Syncing...' : 'Sync Now',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _themeColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _themeColor.withAlpha(80)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'HealthKit sync requires an Apple Watch and iOS device. Data auto-populates your analytics dashboard daily.',
                style: GoogleFonts.nunitoSans(
                  fontSize: 10,
                  color: AppTheme.muted,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _healthKitSyncing
            ? AppTheme.warning.withAlpha(20)
            : AppTheme.success.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _healthKitSyncing ? AppTheme.warning : AppTheme.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _healthKitSyncing ? 'Syncing' : 'Connected',
            style: GoogleFonts.nunitoSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _healthKitSyncing ? AppTheme.warning : AppTheme.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthDataRow(
    String emoji,
    String label,
    String value,
    String sub,
  ) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryDark,
                ),
              ),
              Text(
                sub,
                style: GoogleFonts.nunitoSans(
                  fontSize: 10,
                  color: AppTheme.muted,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.nunitoSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _themeColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthConditionsCard(UserProfile profile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(200),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _themeColor.withAlpha(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Personalization',
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Root personalizes your experience based on these.',
                style: GoogleFonts.nunitoSans(
                  fontSize: 11,
                  color: AppTheme.muted,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: profile.healthConditions
                    .map(
                      (c) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _themeColor.withAlpha(15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _themeColor.withAlpha(40)),
                        ),
                        child: Text(
                          c,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _themeColor,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationTrackingCard(UserProfile? profile) {
    final mode = profile?.locationTrackingMode ?? 'manual';
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(200),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _themeColor.withAlpha(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location Tracking',
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 12),
              _LocationModeOption(
                title: 'Automatic GPS',
                desc: 'Detects your location and logs time automatically',
                emoji: '📍',
                isSelected: mode == 'gps',
                color: _themeColor,
                onTap: () async {
                  if (profile != null) {
                    await _service.saveProfile(
                      profile.copyWith(locationTrackingMode: 'gps'),
                    );
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 8),
              _LocationModeOption(
                title: 'Manual Hourly Log',
                desc: 'Gentle hourly prompts to tap your location',
                emoji: '🕐',
                isSelected: mode == 'manual',
                color: _themeColor,
                onTap: () async {
                  if (profile != null) {
                    await _service.saveProfile(
                      profile.copyWith(locationTrackingMode: 'manual'),
                    );
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _triggerSync() async {
    setState(() => _healthKitSyncing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _healthKitSyncing = false;
        _lastSyncTime = DateTime.now();
      });
    }
  }

  String _formatSyncTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}

class _ProfileChip extends StatelessWidget {
  final String label;
  final Color color;

  const _ProfileChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunitoSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _LocationModeOption extends StatelessWidget {
  final String title;
  final String desc;
  final String emoji;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _LocationModeOption({
    required this.title,
    required this.desc,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(15) : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppTheme.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : AppTheme.primaryDark,
                    ),
                  ),
                  Text(
                    desc,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 11,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}
