import 'package:flutter/material.dart';

enum LocationType { work, school, park, home, gym, other }

class LocationThemeData {
  final LocationType type;
  final String label;
  final String emoji;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color accentColor;
  final Color navBarTint;
  final String description;

  const LocationThemeData({
    required this.type,
    required this.label,
    required this.emoji,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.accentColor,
    required this.navBarTint,
    required this.description,
  });
}

class LocationTheme {
  static const LocationThemeData work = LocationThemeData(
    type: LocationType.work,
    label: 'Work',
    emoji: '💼',
    primaryColor: Color(0xFF5A5A4A),
    secondaryColor: Color(0xFF8A7A6A),
    backgroundColor: Color(0xFFF5F2EE),
    surfaceColor: Color(0xFFEFEBE5),
    accentColor: Color(0xFF7A6A5A),
    navBarTint: Color(0xFF5A5A4A),
    description: 'Focused, minimal energy',
  );

  static const LocationThemeData school = LocationThemeData(
    type: LocationType.school,
    label: 'School',
    emoji: '📚',
    primaryColor: Color(0xFF5A7A3A),
    secondaryColor: Color(0xFF7A9A5A),
    backgroundColor: Color(0xFFF5F8EE),
    surfaceColor: Color(0xFFEEF4E4),
    accentColor: Color(0xFFB8A040),
    navBarTint: Color(0xFF5A7A3A),
    description: 'Bright but calm',
  );

  static const LocationThemeData park = LocationThemeData(
    type: LocationType.park,
    label: 'Park',
    emoji: '🌳',
    primaryColor: Color(0xFF3A6A3A),
    secondaryColor: Color(0xFF6A8A3A),
    backgroundColor: Color(0xFFF0F5EC),
    surfaceColor: Color(0xFFE8F0E0),
    accentColor: Color(0xFFC4A030),
    navBarTint: Color(0xFF3A6A3A),
    description: 'Open and airy',
  );

  static const LocationThemeData home = LocationThemeData(
    type: LocationType.home,
    label: 'Home',
    emoji: '🏡',
    primaryColor: Color(0xFFC4774A),
    secondaryColor: Color(0xFFD4956A),
    backgroundColor: Color(0xFFFAF3EC),
    surfaceColor: Color(0xFFF5EBE0),
    accentColor: Color(0xFFE8A060),
    navBarTint: Color(0xFFC4774A),
    description: 'Cozy and safe',
  );

  static const LocationThemeData gym = LocationThemeData(
    type: LocationType.gym,
    label: 'Gym',
    emoji: '💪',
    primaryColor: Color(0xFF2A6A7A),
    secondaryColor: Color(0xFF4A8A9A),
    backgroundColor: Color(0xFFECF4F5),
    surfaceColor: Color(0xFFE0EEF0),
    accentColor: Color(0xFF3A7A8A),
    navBarTint: Color(0xFF2A6A7A),
    description: 'Energized but calm',
  );

  static const LocationThemeData other = LocationThemeData(
    type: LocationType.other,
    label: 'Other',
    emoji: '📍',
    primaryColor: Color(0xFF5C7A5C),
    secondaryColor: Color(0xFF7A9E7A),
    backgroundColor: Color(0xFFFAF7F2),
    surfaceColor: Color(0xFFF2EDE4),
    accentColor: Color(0xFFC4774A),
    navBarTint: Color(0xFF5C7A5C),
    description: 'Your own space',
  );

  static LocationThemeData fromType(LocationType type) {
    switch (type) {
      case LocationType.work:
        return work;
      case LocationType.school:
        return school;
      case LocationType.park:
        return park;
      case LocationType.home:
        return home;
      case LocationType.gym:
        return gym;
      case LocationType.other:
        return other;
    }
  }

  static const List<LocationThemeData> all = [
    work,
    school,
    park,
    home,
    gym,
    other,
  ];
}

class LocationThemeNotifier extends ChangeNotifier {
  LocationThemeData _current = LocationTheme.other;
  bool _hasSelected = false;

  LocationThemeData get current => _current;
  bool get hasSelected => _hasSelected;

  void select(LocationType type) {
    _current = LocationTheme.fromType(type);
    _hasSelected = true;
    notifyListeners();
  }
}
