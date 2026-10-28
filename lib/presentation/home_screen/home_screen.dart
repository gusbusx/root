import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/user_profile_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/location_theme.dart';
import '../../widgets/app_navigation.dart';
import './widgets/burnout_score_card.dart';
import './widgets/daily_check_in_card.dart';
import './widgets/energy_multiplier_bar.dart';
import './widgets/home_analytics_widget.dart';
import './widgets/home_break_suggestion_widget.dart';
import './widgets/home_garden_widget.dart';
import './widgets/home_mode_badge_widget.dart';
import './widgets/home_stats_row_widget.dart';
import './widgets/home_water_widget.dart';
import './widgets/location_status_chip.dart';

class HomeScreen extends StatefulWidget {
  final LocationThemeNotifier? themeNotifier;
  const HomeScreen({super.key, this.themeNotifier});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final int _streakDays = 7;
  final String _currentMode = 'focus';
  final String _currentLocation = 'Work';
  final int _minutesAtLocation = 134;
  bool _breakCompleted = false;
  bool _showCheckIn = false;

  late AnimationController _greetingController;
  late Animation<double> _greetingFade;

  final _service = UserProfileService();

  @override
  void initState() {
    super.initState();
    _greetingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _greetingFade = CurvedAnimation(
      parent: _greetingController,
      curve: Curves.easeOutCubic,
    );
    _greetingController.forward();
    _loadAndCheckIn();
  }

  Future<void> _loadAndCheckIn() async {
    await _service.load();
    if (mounted && !_service.todayCheckInDone) {
      setState(() => _showCheckIn = true);
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _greetingController.dispose();
    super.dispose();
  }

  void _onWaterTap() {
    _service.addWater().then((_) => setState(() {}));
  }

  void _onBreakCompleted() {
    setState(() {
      _breakCompleted = true;
    });
    _service.addWater(); // award break points via service
  }

  void _showGoalEditor() {
    int tempGoal = _service.waterGoal;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Water Goal',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'How many cups do you want to drink each day?',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      color: AppTheme.muted,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (tempGoal > 1) setModalState(() => tempGoal--);
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.remove_rounded, size: 20),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          Text(
                            '$tempGoal',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryDark,
                              height: 1,
                            ),
                          ),
                          Text(
                            'cups',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          if (tempGoal < 20) setModalState(() => tempGoal++);
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_rounded, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _service.setWaterGoal(tempGoal);
                        setState(() {});
                        Navigator.pop(ctx);
                      },
                      child: const Text('Save Goal'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    final name = _service.firstName;
    if (hour < 12) return 'Good morning, $name';
    if (hour < 17) return 'Good afternoon, $name';
    return 'Good evening, $name';
  }

  String _contextualSubtitle() {
    if (_service.waterCups >= _service.waterGoal) {
      return 'You hit your water goal today 🎉';
    }
    if (_currentMode == 'focus') {
      return 'You\'ve been at $_currentLocation — take it one breath at a time.';
    }
    return '${_service.waterGoal - _service.waterCups} more cups to hit your water goal.';
  }

  Color get _themeColor {
    if (widget.themeNotifier != null) {
      return widget.themeNotifier!.current.primaryColor;
    }
    return AppTheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    if (_showCheckIn) {
      return DailyCheckInCard(
        themeNotifier: widget.themeNotifier,
        onComplete: () {
          setState(() => _showCheckIn = false);
        },
      );
    }

    final isTablet = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      backgroundColor: widget.themeNotifier != null
          ? widget.themeNotifier!.current.backgroundColor
          : AppTheme.background,
      bottomNavigationBar: AppNavigation(
        currentIndex: 0,
        themeNotifier: widget.themeNotifier,
      ),
      body: SafeArea(
        child: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
      ),
    );
  }

  Widget _buildPhoneLayout() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                Expanded(
                  child: FadeTransition(
                    opacity: _greetingFade,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting(),
                          style: GoogleFonts.nunitoSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _themeColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _contextualSubtitle(),
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.muted,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                HomeModeBadgeWidget(mode: _currentMode),
              ],
            ),
          ),
        ),
        // Location chip
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Row(
              children: [
                LocationStatusChip(
                  currentLocation: _currentLocation,
                  minutesAtLocation: _minutesAtLocation,
                  themeNotifier: widget.themeNotifier,
                ),
              ],
            ),
          ),
        ),
        // Energy multiplier bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: EnergyMultiplierBar(themeNotifier: widget.themeNotifier),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        // Burnout score
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BurnoutScoreCard(themeNotifier: widget.themeNotifier),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: HomeWaterWidget(
            cupsLogged: _service.waterCups,
            cupsGoal: _service.waterGoal,
            onTap: _onWaterTap,
            onGoalEdit: _showGoalEditor,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: HomeStatsRowWidget(
            points: _service.totalPoints,
            streakDays: _streakDays,
            waterCups: _service.waterCups,
            waterGoal: _service.waterGoal,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: HomeGardenWidget(points: _service.totalPoints),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        // Manual location timeline
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ManualHourlyTimeline(themeNotifier: widget.themeNotifier),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: HomeAnalyticsWidget(themeNotifier: widget.themeNotifier),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: HomeBreakSuggestionWidget(
              mode: _currentMode,
              isCompleted: _breakCompleted,
              onComplete: _onBreakCompleted,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: _greetingFade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(),
                        style: GoogleFonts.nunitoSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: _themeColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _contextualSubtitle(),
                        style: GoogleFonts.nunitoSans(
                          fontSize: 14,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                LocationStatusChip(
                  currentLocation: _currentLocation,
                  minutesAtLocation: _minutesAtLocation,
                  themeNotifier: widget.themeNotifier,
                ),
                const SizedBox(height: 12),
                EnergyMultiplierBar(themeNotifier: widget.themeNotifier),
                const SizedBox(height: 16),
                BurnoutScoreCard(themeNotifier: widget.themeNotifier),
                const SizedBox(height: 20),
                HomeWaterWidget(
                  cupsLogged: _service.waterCups,
                  cupsGoal: _service.waterGoal,
                  onTap: _onWaterTap,
                  onGoalEdit: _showGoalEditor,
                ),
                const SizedBox(height: 20),
                HomeAnalyticsWidget(themeNotifier: widget.themeNotifier),
              ],
            ),
          ),
          const SizedBox(width: 28),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                HomeModeBadgeWidget(mode: _currentMode),
                const SizedBox(height: 20),
                HomeStatsRowWidget(
                  points: _service.totalPoints,
                  streakDays: _streakDays,
                  waterCups: _service.waterCups,
                  waterGoal: _service.waterGoal,
                ),
                const SizedBox(height: 20),
                HomeGardenWidget(points: _service.totalPoints),
                const SizedBox(height: 20),
                ManualHourlyTimeline(themeNotifier: widget.themeNotifier),
                const SizedBox(height: 20),
                HomeBreakSuggestionWidget(
                  mode: _currentMode,
                  isCompleted: _breakCompleted,
                  onComplete: _onBreakCompleted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
