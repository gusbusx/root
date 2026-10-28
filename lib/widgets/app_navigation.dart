import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../theme/location_theme.dart';
import '../routes/app_routes.dart';

class AppNavigation extends StatefulWidget {
  final int currentIndex;
  final LocationThemeNotifier? themeNotifier;

  const AppNavigation({
    super.key,
    required this.currentIndex,
    this.themeNotifier,
  });

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _leafController;
  late Animation<double> _leafSway;

  @override
  void initState() {
    super.initState();
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _leafSway = Tween<double>(begin: -0.12, end: 0.12).animate(
      CurvedAnimation(parent: _leafController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _leafController.dispose();
    super.dispose();
  }

  Color get _tintColor {
    if (widget.themeNotifier != null) {
      return widget.themeNotifier!.current.navBarTint;
    }
    return AppTheme.primary;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeScreen,
          (r) => false,
        );
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.meditationScreen,
          (r) => false,
        );
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.locationModeScreen,
          (r) => false,
        );
        break;
      case 3:
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.yourStoryScreen,
          (r) => false,
        );
        break;
      case 4:
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.profileSettingsScreen,
          (r) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 1000;
    if (isTablet) {
      return _buildTabletRail(context);
    }
    return _buildPhoneNav(context);
  }

  Widget _buildPhoneNav(BuildContext context) {
    final tint = _tintColor;

    return ListenableBuilder(
      listenable: widget.themeNotifier ?? ValueNotifier(null),
      builder: (context, _) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: tint.withAlpha(25),
                border: Border(
                  top: BorderSide(color: tint.withAlpha(40), width: 0.5),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withAlpha(180),
                    Colors.white.withAlpha(220),
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Home
                    Expanded(
                      child: _NavButton(
                        icon: Icons.spa_rounded,
                        label: 'Home',
                        isActive: widget.currentIndex == 0,
                        activeColor: tint,
                        onTap: () => _onTap(context, 0),
                      ),
                    ),
                    // Story
                    Expanded(
                      child: _NavButton(
                        icon: Icons.auto_stories_rounded,
                        label: 'Story',
                        isActive: widget.currentIndex == 3,
                        activeColor: tint,
                        onTap: () => _onTap(context, 3),
                      ),
                    ),
                    // Center leaf button (Meditation)
                    _CenterLeafButton(
                      isActive: widget.currentIndex == 1,
                      activeColor: tint,
                      leafSway: _leafSway,
                      onTap: () => _onTap(context, 1),
                    ),
                    // Location
                    Expanded(
                      child: _NavButton(
                        icon: Icons.location_on_rounded,
                        label: 'Mode',
                        isActive: widget.currentIndex == 2,
                        activeColor: tint,
                        onTap: () => _onTap(context, 2),
                      ),
                    ),
                    // Profile
                    Expanded(
                      child: _NavButton(
                        icon: Icons.person_rounded,
                        label: 'Profile',
                        isActive: widget.currentIndex == 4,
                        activeColor: tint,
                        onTap: () => _onTap(context, 4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabletRail(BuildContext context) {
    final tint = _tintColor;
    final railIndex = widget.currentIndex == 1
        ? 1
        : widget.currentIndex == 2
        ? 2
        : widget.currentIndex == 3
        ? 3
        : widget.currentIndex == 4
        ? 4
        : 0;
    return NavigationRail(
      selectedIndex: railIndex,
      backgroundColor: AppTheme.surface,
      indicatorColor: tint.withAlpha(31),
      selectedIconTheme: IconThemeData(color: tint),
      unselectedIconTheme: IconThemeData(color: AppTheme.muted),
      labelType: NavigationRailLabelType.selected,
      selectedLabelTextStyle: GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: tint,
      ),
      unselectedLabelTextStyle: GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppTheme.muted,
      ),
      onDestinationSelected: (i) => _onTap(context, i),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.spa_rounded),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.eco_rounded),
          label: Text('Meditate'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.location_on_rounded),
          label: Text('Mode'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.auto_stories_rounded),
          label: Text('Story'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_rounded),
          label: Text('Profile'),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: activeColor.withAlpha(20),
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: isActive ? activeColor : AppTheme.muted),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? 5 : 0,
            height: isActive ? 5 : 0,
            decoration: BoxDecoration(
              color: activeColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterLeafButton extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final Animation<double> leafSway;
  final VoidCallback onTap;

  const _CenterLeafButton({
    required this.isActive,
    required this.activeColor,
    required this.leafSway,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: leafSway,
        builder: (context, _) {
          return Transform.rotate(
            angle: leafSway.value,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isActive ? activeColor : activeColor.withAlpha(200),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withAlpha(60),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.eco_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          );
        },
      ),
    );
  }
}
