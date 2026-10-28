import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/user_profile_service.dart';
import '../../theme/app_theme.dart';
import '../../theme/location_theme.dart';
import '../../widgets/app_navigation.dart';

class YourStoryScreen extends StatefulWidget {
  final LocationThemeNotifier? themeNotifier;

  const YourStoryScreen({super.key, this.themeNotifier});

  @override
  State<YourStoryScreen> createState() => _YourStoryScreenState();
}

class _YourStoryScreenState extends State<YourStoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  final _service = UserProfileService();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Color get _themeColor =>
      widget.themeNotifier?.current.primaryColor ?? AppTheme.primary;

  Color get _bgColor =>
      widget.themeNotifier?.current.backgroundColor ?? AppTheme.background;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      bottomNavigationBar: AppNavigation(
        currentIndex: 3,
        themeNotifier: widget.themeNotifier,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Story',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'A gentle look at how you\'ve been',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildWeeklySummaryCard(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildChartCard(
                    title: 'Sleep Duration',
                    subtitle: 'Last 7 nights',
                    insight: _sleepInsight(),
                    chart: _buildSleepChart(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildChartCard(
                    title: 'Water Intake',
                    subtitle: 'vs. daily goal',
                    insight: _waterInsight(),
                    chart: _buildWaterChart(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildChartCard(
                    title: 'Location Time',
                    subtitle: 'Work vs. Rest this week',
                    insight: _locationInsight(),
                    chart: _buildLocationDonut(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildChartCard(
                    title: 'Meditation Minutes',
                    subtitle: 'Last 7 days',
                    insight: _meditationInsight(),
                    chart: _buildMeditationChart(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildChartCard(
                    title: 'Screen Time',
                    subtitle: 'Daily hours with recommended limit',
                    insight: _screenTimeInsight(),
                    chart: _buildScreenTimeChart(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildChartCard(
                    title: 'Resting Heart Rate',
                    subtitle: 'Last 7 days (bpm)',
                    insight: _heartRateInsight(),
                    chart: _buildHeartRateChart(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildChartCard(
                    title: 'Burnout Score',
                    subtitle: 'Last 7 days trend',
                    insight: _burnoutInsight(),
                    chart: _buildBurnoutChart(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklySummaryCard() {
    final data = _service.wellnessHistory;
    final avgSleep = data.isEmpty
        ? 0.0
        : data.map((d) => d.sleepHours).reduce((a, b) => a + b) / data.length;
    final totalMed = data.isEmpty
        ? 0
        : data.map((d) => d.meditationMinutes).reduce((a, b) => a + b);
    final avgBurnout = data.isEmpty
        ? 0.0
        : data.map((d) => d.burnoutScore).reduce((a, b) => a + b) / data.length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_themeColor.withAlpha(30), _themeColor.withAlpha(10)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _themeColor.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_stories_rounded,
                    size: 18,
                    color: _themeColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'This Week\'s Highlights',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _SummaryTile(
                    emoji: '😴',
                    label: 'Avg Sleep',
                    value: '${avgSleep.toStringAsFixed(1)}h',
                    color: _themeColor,
                  ),
                  _SummaryTile(
                    emoji: '🧘',
                    label: 'Meditation',
                    value: '${totalMed}m',
                    color: _themeColor,
                  ),
                  _SummaryTile(
                    emoji: '🌿',
                    label: 'Burnout',
                    value: avgBurnout.toInt().toString(),
                    color: _service.burnoutColor,
                  ),
                  _SummaryTile(
                    emoji: '💧',
                    label: 'Water',
                    value: '${_service.waterCups}/${_service.waterGoal}',
                    color: AppTheme.waterBlue,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(150),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _weeklyNarrative(),
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: AppTheme.primaryDark,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required String insight,
    required Widget chart,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(200),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _themeColor.withAlpha(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryDark,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.nunitoSans(
                  fontSize: 11,
                  color: AppTheme.muted,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(height: 140, child: chart),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _themeColor.withAlpha(12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 13,
                      color: _themeColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        insight,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 11,
                          color: AppTheme.primaryDark,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepChart() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return const SizedBox();
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: AppTheme.cardBorder, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 28,
              getTitlesWidget: (v, _) => Text(
                '${v.toInt()}h',
                style: GoogleFonts.nunitoSans(
                  fontSize: 9,
                  color: AppTheme.muted,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                final i = v.toInt();
                if (i < 0 || i >= days.length) return const SizedBox();
                return Text(
                  days[i],
                  style: GoogleFonts.nunitoSans(
                    fontSize: 9,
                    color: AppTheme.muted,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.sleepHours))
                .toList(),
            isCurved: true,
            color: _themeColor,
            barWidth: 2.5,
            dotData: FlDotData(
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 3,
                color: _themeColor,
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: _themeColor.withAlpha(30),
            ),
          ),
          // 7h target line
          LineChartBarData(
            spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), 7)),
            isCurved: false,
            color: AppTheme.primary.withAlpha(80),
            barWidth: 1,
            dashArray: [4, 4],
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterChart() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return const SizedBox();
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                final i = v.toInt();
                if (i < 0 || i >= days.length) return const SizedBox();
                return Text(
                  days[i],
                  style: GoogleFonts.nunitoSans(
                    fontSize: 9,
                    color: AppTheme.muted,
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((e) {
          final pct = (e.value.waterCups / e.value.waterGoal).clamp(0.0, 1.0);
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.waterCups.toDouble(),
                color: AppTheme.waterBlue.withAlpha((pct * 255).toInt()),
                width: 16,
                borderRadius: BorderRadius.circular(4),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: e.value.waterGoal.toDouble(),
                  color: AppTheme.waterBlue.withAlpha(30),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLocationDonut() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return const SizedBox();
    final totalWork = data
        .map((d) => d.workLocationMinutes)
        .reduce((a, b) => a + b)
        .toDouble();
    final totalRest = data
        .map((d) => d.restLocationMinutes)
        .reduce((a, b) => a + b)
        .toDouble();
    final total = totalWork + totalRest;
    if (total == 0) return const SizedBox();

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 35,
              sections: [
                PieChartSectionData(
                  value: totalWork,
                  color: const Color(0xFF5A5A4A),
                  title: '${(totalWork / total * 100).toInt()}%',
                  titleStyle: GoogleFonts.nunitoSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  radius: 40,
                ),
                PieChartSectionData(
                  value: totalRest,
                  color: AppTheme.primary,
                  title: '${(totalRest / total * 100).toInt()}%',
                  titleStyle: GoogleFonts.nunitoSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  radius: 40,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LegendItem(color: const Color(0xFF5A5A4A), label: 'Work'),
            const SizedBox(height: 8),
            _LegendItem(color: AppTheme.primary, label: 'Rest'),
          ],
        ),
      ],
    );
  }

  Widget _buildMeditationChart() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return const SizedBox();
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                final i = v.toInt();
                if (i < 0 || i >= days.length) return const SizedBox();
                return Text(
                  days[i],
                  style: GoogleFonts.nunitoSans(
                    fontSize: 9,
                    color: AppTheme.muted,
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data
            .asMap()
            .entries
            .map(
              (e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: e.value.meditationMinutes.toDouble(),
                    color: const Color(0xFF3A6A4A),
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildScreenTimeChart() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return const SizedBox();
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                final i = v.toInt();
                if (i < 0 || i >= days.length) return const SizedBox();
                return Text(
                  days[i],
                  style: GoogleFonts.nunitoSans(
                    fontSize: 9,
                    color: AppTheme.muted,
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.screenTimeHours))
                .toList(),
            isCurved: true,
            color: AppTheme.secondary,
            barWidth: 2.5,
            dotData: FlDotData(
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 3,
                color: AppTheme.secondary,
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.secondary.withAlpha(25),
            ),
          ),
          // 4h recommended limit
          LineChartBarData(
            spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), 4)),
            isCurved: false,
            color: AppTheme.primary.withAlpha(100),
            barWidth: 1,
            dashArray: [4, 4],
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateChart() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return const SizedBox();
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                final i = v.toInt();
                if (i < 0 || i >= days.length) return const SizedBox();
                return Text(
                  days[i],
                  style: GoogleFonts.nunitoSans(
                    fontSize: 9,
                    color: AppTheme.muted,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (v, _) => Text(
                v.toInt().toString(),
                style: GoogleFonts.nunitoSans(
                  fontSize: 9,
                  color: AppTheme.muted,
                ),
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 55,
        maxY: 90,
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.restingHeartRate))
                .toList(),
            isCurved: true,
            color: const Color(0xFFB85C3A),
            barWidth: 2.5,
            dotData: FlDotData(
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 3,
                color: const Color(0xFFB85C3A),
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFFB85C3A).withAlpha(20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBurnoutChart() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return const SizedBox();
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              FlLine(color: AppTheme.cardBorder, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                final i = v.toInt();
                if (i < 0 || i >= days.length) return const SizedBox();
                return Text(
                  days[i],
                  style: GoogleFonts.nunitoSans(
                    fontSize: 9,
                    color: AppTheme.muted,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (v, _) => Text(
                v.toInt().toString(),
                style: GoogleFonts.nunitoSans(
                  fontSize: 9,
                  color: AppTheme.muted,
                ),
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 100,
        rangeAnnotations: RangeAnnotations(
          horizontalRangeAnnotations: [
            HorizontalRangeAnnotation(
              y1: 0,
              y2: 50,
              color: AppTheme.primary.withAlpha(15),
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.burnoutScore))
                .toList(),
            isCurved: true,
            color: _service.burnoutColor,
            barWidth: 2.5,
            dotData: FlDotData(
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 3,
                color: _service.burnoutColor,
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: _service.burnoutColor.withAlpha(20),
            ),
          ),
        ],
      ),
    );
  }

  // Insight generators
  String _sleepInsight() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return 'Start logging to see your sleep patterns.';
    final goodNights = data.where((d) => d.sleepHours >= 7).length;
    if (goodNights >= 5) {
      return 'You slept well $goodNights out of ${data.length} nights — your body is getting the rest it needs. 🌙';
    }
    if (goodNights >= 3) {
      return 'You hit your sleep goal $goodNights nights this week. A little more rest could make a big difference.';
    }
    return 'Sleep has been shorter than ideal this week. Even 30 more minutes can shift how you feel.';
  }

  String _waterInsight() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return 'Tap the glass on your home screen to log water.';
    final goalDays = data.where((d) => d.waterCups >= d.waterGoal).length;
    if (goalDays >= 5) {
      return 'You hit your water goal $goalDays days this week — beautifully consistent. 💧';
    }
    return 'You reached your water goal $goalDays out of ${data.length} days. Small sips throughout the day add up.';
  }

  String _locationInsight() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return 'Log your locations to see your balance.';
    final totalWork = data
        .map((d) => d.workLocationMinutes)
        .reduce((a, b) => a + b);
    final totalRest = data
        .map((d) => d.restLocationMinutes)
        .reduce((a, b) => a + b);
    if (totalRest > totalWork) {
      return 'You spent more time in rest spaces than work this week — great balance. 🌿';
    }
    if (totalWork > totalRest * 2) {
      return 'Work dominated your week. Consider carving out more time in restorative spaces.';
    }
    return 'Your work and rest time are fairly balanced this week.';
  }

  String _meditationInsight() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return 'Try a short session from the meditation tab.';
    final totalMin = data
        .map((d) => d.meditationMinutes)
        .reduce((a, b) => a + b);
    if (totalMin >= 60) {
      return 'You meditated for $totalMin minutes this week — that\'s a meaningful investment in your calm. 🧘';
    }
    if (totalMin > 0) {
      return 'You found $totalMin minutes for stillness this week. Every minute counts.';
    }
    return 'No meditation logged this week. Even 5 minutes can shift your nervous system.';
  }

  String _screenTimeInsight() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return 'Screen time data will appear here.';
    final highDays = data.where((d) => d.screenTimeHours > 4).length;
    if (highDays == 0) {
      return 'Screen time stayed under the recommended limit all week. 🌟';
    }
    if (highDays >= 4) {
      return 'Screen time was high $highDays days this week. Your burnout score reflected that.';
    }
    return 'Screen time spiked on a few days. Notice how those days felt compared to lighter ones.';
  }

  String _heartRateInsight() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) return 'Heart rate data will appear here.';
    final avgHR =
        data.map((d) => d.restingHeartRate).reduce((a, b) => a + b) /
        data.length;
    if (avgHR < 68) {
      return 'Your resting heart rate averaged ${avgHR.toInt()} bpm — a sign of good cardiovascular health. ❤️';
    }
    if (avgHR > 75) {
      return 'Your resting heart rate has been elevated. More rest and less stress can help bring it down.';
    }
    return 'Your heart rate is in a healthy range this week.';
  }

  String _burnoutInsight() {
    return _service.burnoutPrediction;
  }

  String _weeklyNarrative() {
    final data = _service.wellnessHistory;
    if (data.isEmpty) {
      return 'Keep logging your wellness habits to see your weekly story unfold.';
    }
    final avgBurnout =
        data.map((d) => d.burnoutScore).reduce((a, b) => a + b) / data.length;
    if (avgBurnout < 30) {
      return 'This was a genuinely good week for you. Your habits are working. 🌱';
    }
    if (avgBurnout < 50) {
      return 'A balanced week overall. A few more restorative moments could tip you toward thriving.';
    }
    return 'This week had some strain. You\'re aware of it — that\'s the first step toward change.';
  }
}

class _SummaryTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;

  const _SummaryTile({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.nunitoSans(fontSize: 9, color: AppTheme.muted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 12,
            color: AppTheme.primaryDark,
          ),
        ),
      ],
    );
  }
}
