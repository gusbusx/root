import 'package:flutter/material.dart';

import '../presentation/home_screen/home_screen.dart';
import '../presentation/location_mode_screen/location_mode_screen.dart';
import '../presentation/location_selector_screen/location_selector_screen.dart';
import '../presentation/meditation_screen/meditation_screen.dart';
import '../presentation/onboarding_screen/onboarding_screen.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';
import '../presentation/your_story_screen/your_story_screen.dart';
import '../theme/location_theme.dart';

class AppRoutes {
  static const String initial = '/';
  static const String onboardingScreen = '/onboarding-screen';
  static const String locationSelectorScreen = '/location-selector-screen';
  static const String homeScreen = '/home-screen';
  static const String locationModeScreen = '/location-mode-screen';
  static const String meditationScreen = '/meditation-screen';
  static const String yourStoryScreen = '/your-story-screen';
  static const String profileSettingsScreen = '/profile-settings-screen';

  static final LocationThemeNotifier _themeNotifier = LocationThemeNotifier();

  static Map<String, WidgetBuilder> get routes => {
    initial: (context) => const OnboardingScreen(),
    onboardingScreen: (context) => const OnboardingScreen(),
    locationSelectorScreen: (context) =>
        LocationSelectorScreen(themeNotifier: _themeNotifier),
    homeScreen: (context) => HomeScreen(themeNotifier: _themeNotifier),
    locationModeScreen: (context) =>
        LocationModeScreen(themeNotifier: _themeNotifier),
    meditationScreen: (context) =>
        MeditationScreen(themeNotifier: _themeNotifier),
    yourStoryScreen: (context) =>
        YourStoryScreen(themeNotifier: _themeNotifier),
    profileSettingsScreen: (context) =>
        ProfileSettingsScreen(themeNotifier: _themeNotifier),
  };
}
