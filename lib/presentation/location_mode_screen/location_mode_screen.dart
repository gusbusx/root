import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../theme/location_theme.dart';
import '../../widgets/app_navigation.dart';
import './widgets/location_gps_toggle_widget.dart';
import './widgets/location_manual_checkin_widget.dart';
import './widgets/location_mode_illustration_widget.dart';
import './widgets/location_mode_info_widget.dart';

class LocationModeScreen extends StatefulWidget {
  final LocationThemeNotifier? themeNotifier;
  const LocationModeScreen({super.key, this.themeNotifier});

  @override
  State<LocationModeScreen> createState() => _LocationModeScreenState();
}

class _LocationModeScreenState extends State<LocationModeScreen>
    with SingleTickerProviderStateMixin {
  String _currentMode = 'focus';
  String _currentLocation = 'Work';
  bool _gpsEnabled = false;
  bool _gpsLoading = false;

  late AnimationController _modeTransitionController;
  late Animation<double> _modeFade;

  final List<Map<String, dynamic>> _locationOptions = [
    {'label': 'Work', 'icon': Icons.business_rounded, 'mode': 'focus'},
    {'label': 'School', 'icon': Icons.school_rounded, 'mode': 'focus'},
    {'label': 'Park', 'icon': Icons.park_rounded, 'mode': 'rest'},
    {'label': 'Gym', 'icon': Icons.fitness_center_rounded, 'mode': 'rest'},
    {'label': 'Home', 'icon': Icons.home_rounded, 'mode': 'home'},
    {'label': 'Other', 'icon': Icons.place_rounded, 'mode': 'home'},
  ];

  @override
  void initState() {
    super.initState();
    _modeTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _modeFade = CurvedAnimation(
      parent: _modeTransitionController,
      curve: Curves.easeOutCubic,
    );
    _modeTransitionController.forward();
  }

  @override
  void dispose() {
    _modeTransitionController.dispose();
    super.dispose();
  }

  void _selectLocation(String location, String mode) {
    if (_currentLocation == location) return;
    _modeTransitionController.reset();
    setState(() {
      _currentLocation = location;
      _currentMode = mode;
    });
    // Also update the app-wide theme
    final locMap = {
      'Work': LocationType.work,
      'School': LocationType.school,
      'Park': LocationType.park,
      'Gym': LocationType.gym,
      'Home': LocationType.home,
      'Other': LocationType.other,
    };
    if (widget.themeNotifier != null && locMap.containsKey(location)) {
      widget.themeNotifier!.select(locMap[location]!);
    }
    _modeTransitionController.forward();
  }

  void _toggleGps(bool value) async {
    setState(() => _gpsLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _gpsEnabled = value;
      _gpsLoading = false;
    });
  }

  Color get _modeBackgroundColor {
    if (widget.themeNotifier != null) {
      return widget.themeNotifier!.current.backgroundColor;
    }
    switch (_currentMode) {
      case 'focus':
        return AppTheme.focusModeTint.withAlpha(15);
      case 'rest':
        return AppTheme.restModeTint.withAlpha(15);
      default:
        return AppTheme.homeModeTint.withAlpha(15);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      color: _modeBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: AppNavigation(
          currentIndex: 2,
          themeNotifier: widget.themeNotifier,
        ),
        body: SafeArea(
          child: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
        ),
      ),
    );
  }

  Widget _buildPhoneLayout() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _modeFade,
            child: LocationModeIllustrationWidget(mode: _currentMode),
          ),
        ),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _modeFade,
            child: LocationModeInfoWidget(
              mode: _currentMode,
              location: _currentLocation,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: LocationGpsToggleWidget(
              isEnabled: _gpsEnabled,
              isLoading: _gpsLoading,
              onToggle: _toggleGps,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: LocationManualCheckinWidget(
              locationOptions: _locationOptions,
              selectedLocation: _currentLocation,
              gpsEnabled: _gpsEnabled,
              onLocationSelected: _selectLocation,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: FadeTransition(
            opacity: _modeFade,
            child: LocationModeIllustrationWidget(
              mode: _currentMode,
              isTablet: true,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: _modeFade,
                  child: LocationModeInfoWidget(
                    mode: _currentMode,
                    location: _currentLocation,
                  ),
                ),
                const SizedBox(height: 20),
                LocationGpsToggleWidget(
                  isEnabled: _gpsEnabled,
                  isLoading: _gpsLoading,
                  onToggle: _toggleGps,
                ),
                const SizedBox(height: 20),
                LocationManualCheckinWidget(
                  locationOptions: _locationOptions,
                  selectedLocation: _currentLocation,
                  gpsEnabled: _gpsEnabled,
                  onLocationSelected: _selectLocation,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
