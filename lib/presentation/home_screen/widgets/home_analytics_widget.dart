import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/location_theme.dart';

class HomeAnalyticsWidget extends StatefulWidget {
  final LocationThemeNotifier? themeNotifier;

  const HomeAnalyticsWidget({super.key, this.themeNotifier});

  @override
  State<HomeAnalyticsWidget> createState() => _HomeAnalyticsWidgetState();
}

class _HomeAnalyticsWidgetState extends State<HomeAnalyticsWidget> {
  int _selectedTab = 0;

  // Mock 7-day data
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<double> _workHours = [6.5, 7.0, 8.0, 5.5, 7.5, 2.0, 1.0];
  final List<double> _restHours = [2.0, 1.5, 1.0, 3.0, 2.5, 5.0, 6.0];
  final List<double> _meditationMins = [10, 0, 15, 10, 0, 20, 30];
  final List<double> _waterCups = [6, 8, 5, 7, 8, 9, 6];
  final int _waterGoal = 8;

  final List<String> _tabs = ['Work', 'Rest', 'Meditate', 'Water'];

  String _generateInsight() {
    final totalWork = _workHours.reduce((a, b) => a + b);
    final totalRest = _restHours.reduce((a, b) => a + b);
    final totalMed = _meditationMins.reduce((a, b) => a + b);
    final avgWater = _waterCups.reduce((a, b) => a + b) / 7;

    if (_selectedTab == 0) {
      if (totalWork > 40) {
        return 'Your work sessions were long Mon–Wed. Consider more breaks next week.';
      }
      return 'Good balance this week — you kept work sessions manageable.';
    } else if (_selectedTab == 1) {
      if (totalRest > totalWork) {
        return 'You rested more than you worked this week — great balance.';
      }
      return 'Try to carve out more rest time — your body will thank you.';
    } else if (_selectedTab == 2) {
      if (totalMed >= 60) {
        return 'Excellent meditation week — ${totalMed.toInt()} minutes of calm logged.';
      }
      return 'Even a few minutes daily adds up. Try a short session tomorrow.';
    } else {
      if (avgWater >= _waterGoal) {
        return 'You hit your water goal most days this week — keep it up!';
      }
      return 'You averaged ${avgWater.toStringAsFixed(1)} cups/day. Try to reach your goal more consistently.';
    }
  }

  Color get _activeColor {
    if (widget.themeNotifier != null) {
      return widget.themeNotifier!.current.primaryColor;
    }
    return AppTheme.primary;
  }

  List<BarChartGroupData> _buildBarGroups() {
    List<double> data;
    switch (_selectedTab) {
      case 0:
        data = _workHours;
        break;
      case 1:
        data = _restHours;
        break;
      case 2:
        data = _meditationMins;
        break;
      default:
        data = _waterCups;
    }

    return List.generate(7, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i],
            color: _activeColor.withAlpha(200),
            width: 18,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _selectedTab == 2 ? 60 : (_selectedTab == 3 ? 12 : 10),
              color: _activeColor.withAlpha(20),
            ),
          ),
        ],
      );
    });
  }

  String _yAxisLabel(double value) {
    if (_selectedTab == 2) return '${value.toInt()}m';
    if (_selectedTab == 3) return '${value.toInt()}c';
    return '${value.toInt()}h';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'How you\'ve been',
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryDark,
                ),
              ),
              const Spacer(),
              Text(
                'Last 7 days',
                style: GoogleFonts.nunitoSans(
                  fontSize: 11,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Tab selector
          Row(
            children: List.generate(_tabs.length, (i) {
              final isActive = _selectedTab == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? _activeColor.withAlpha(30)
                        : AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? _activeColor.withAlpha(100)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    _tabs[i],
                    style: GoogleFonts.nunitoSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isActive ? _activeColor : AppTheme.muted,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          // Bar chart
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _selectedTab == 2 ? 60 : (_selectedTab == 3 ? 12 : 10),
                barGroups: _buildBarGroups(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _selectedTab == 2
                      ? 20
                      : (_selectedTab == 3 ? 4 : 2),
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: AppTheme.cardBorder, strokeWidth: 0.8),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: _selectedTab == 2
                          ? 20
                          : (_selectedTab == 3 ? 4 : 2),
                      getTitlesWidget: (value, meta) => Text(
                        _yAxisLabel(value),
                        style: GoogleFonts.nunitoSans(
                          fontSize: 9,
                          color: AppTheme.muted,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= 7) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _days[i],
                            style: GoogleFonts.nunitoSans(
                              fontSize: 10,
                              color: AppTheme.muted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Auto-generated insight
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _activeColor.withAlpha(15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _activeColor.withAlpha(40)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome_rounded, size: 14, color: _activeColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _generateInsight(),
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: AppTheme.primaryDark,
                      fontWeight: FontWeight.w400,
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
