import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProfile {
  final String firstName;
  final int age;
  final String occupation;
  final String profileType;
  final bool inSchool;
  final bool playsSports;
  final List<String> healthConditions;
  final String locationTrackingMode; // 'gps' or 'manual'

  const UserProfile({
    required this.firstName,
    required this.age,
    required this.occupation,
    required this.profileType,
    required this.inSchool,
    required this.playsSports,
    required this.healthConditions,
    required this.locationTrackingMode,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'age': age,
    'occupation': occupation,
    'profileType': profileType,
    'inSchool': inSchool,
    'playsSports': playsSports,
    'healthConditions': healthConditions,
    'locationTrackingMode': locationTrackingMode,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    firstName: json['firstName'] ?? '',
    age: json['age'] ?? 0,
    occupation: json['occupation'] ?? '',
    profileType: json['profileType'] ?? '',
    inSchool: json['inSchool'] ?? false,
    playsSports: json['playsSports'] ?? false,
    healthConditions: List<String>.from(json['healthConditions'] ?? []),
    locationTrackingMode: json['locationTrackingMode'] ?? 'manual',
  );

  UserProfile copyWith({
    String? firstName,
    int? age,
    String? occupation,
    String? profileType,
    bool? inSchool,
    bool? playsSports,
    List<String>? healthConditions,
    String? locationTrackingMode,
  }) => UserProfile(
    firstName: firstName ?? this.firstName,
    age: age ?? this.age,
    occupation: occupation ?? this.occupation,
    profileType: profileType ?? this.profileType,
    inSchool: inSchool ?? this.inSchool,
    playsSports: playsSports ?? this.playsSports,
    healthConditions: healthConditions ?? this.healthConditions,
    locationTrackingMode: locationTrackingMode ?? this.locationTrackingMode,
  );
}

class MeditationSession {
  final String id;
  final DateTime date;
  final int durationMinutes;
  final String moodTag;
  final String mode;

  const MeditationSession({
    required this.id,
    required this.date,
    required this.durationMinutes,
    required this.moodTag,
    required this.mode,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'durationMinutes': durationMinutes,
    'moodTag': moodTag,
    'mode': mode,
  };

  factory MeditationSession.fromJson(Map<String, dynamic> json) =>
      MeditationSession(
        id: json['id'] ?? '',
        date: DateTime.parse(json['date']),
        durationMinutes: json['durationMinutes'] ?? 0,
        moodTag: json['moodTag'] ?? 'Calm',
        mode: json['mode'] ?? 'free',
      );
}

class DailyCheckIn {
  final DateTime date;
  final double sleepQuality;
  final String mood;
  final bool didRestfulActivity;
  final bool completed;

  const DailyCheckIn({
    required this.date,
    required this.sleepQuality,
    required this.mood,
    required this.didRestfulActivity,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'sleepQuality': sleepQuality,
    'mood': mood,
    'didRestfulActivity': didRestfulActivity,
    'completed': completed,
  };

  factory DailyCheckIn.fromJson(Map<String, dynamic> json) => DailyCheckIn(
    date: DateTime.parse(json['date']),
    sleepQuality: (json['sleepQuality'] ?? 3.0).toDouble(),
    mood: json['mood'] ?? 'Okay',
    didRestfulActivity: json['didRestfulActivity'] ?? false,
    completed: json['completed'] ?? false,
  );
}

class LocationLog {
  final DateTime timestamp;
  final String location;
  final int minutesSpent;

  const LocationLog({
    required this.timestamp,
    required this.location,
    required this.minutesSpent,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'location': location,
    'minutesSpent': minutesSpent,
  };

  factory LocationLog.fromJson(Map<String, dynamic> json) => LocationLog(
    timestamp: DateTime.parse(json['timestamp']),
    location: json['location'] ?? 'Other',
    minutesSpent: json['minutesSpent'] ?? 0,
  );
}

class WellnessData {
  final DateTime date;
  final double sleepHours;
  final int waterCups;
  final int waterGoal;
  final int meditationMinutes;
  final double restingHeartRate;
  final double screenTimeHours;
  final int workLocationMinutes;
  final int restLocationMinutes;
  final double burnoutScore;
  final int points;

  const WellnessData({
    required this.date,
    required this.sleepHours,
    required this.waterCups,
    required this.waterGoal,
    required this.meditationMinutes,
    required this.restingHeartRate,
    required this.screenTimeHours,
    required this.workLocationMinutes,
    required this.restLocationMinutes,
    required this.burnoutScore,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'sleepHours': sleepHours,
    'waterCups': waterCups,
    'waterGoal': waterGoal,
    'meditationMinutes': meditationMinutes,
    'restingHeartRate': restingHeartRate,
    'screenTimeHours': screenTimeHours,
    'workLocationMinutes': workLocationMinutes,
    'restLocationMinutes': restLocationMinutes,
    'burnoutScore': burnoutScore,
    'points': points,
  };

  factory WellnessData.fromJson(Map<String, dynamic> json) => WellnessData(
    date: DateTime.parse(json['date']),
    sleepHours: (json['sleepHours'] ?? 7.0).toDouble(),
    waterCups: json['waterCups'] ?? 0,
    waterGoal: json['waterGoal'] ?? 8,
    meditationMinutes: json['meditationMinutes'] ?? 0,
    restingHeartRate: (json['restingHeartRate'] ?? 68.0).toDouble(),
    screenTimeHours: (json['screenTimeHours'] ?? 3.0).toDouble(),
    workLocationMinutes: json['workLocationMinutes'] ?? 0,
    restLocationMinutes: json['restLocationMinutes'] ?? 0,
    burnoutScore: (json['burnoutScore'] ?? 30.0).toDouble(),
    points: json['points'] ?? 0,
  );
}

class UserProfileService extends ChangeNotifier {
  static final UserProfileService _instance = UserProfileService._internal();
  factory UserProfileService() => _instance;
  UserProfileService._internal();

  UserProfile? _profile;
  List<MeditationSession> _meditationSessions = [];
  List<DailyCheckIn> _checkIns = [];
  List<LocationLog> _locationLogs = [];
  List<WellnessData> _wellnessHistory = [];
  int _totalPoints = 420;
  int _waterCups = 3;
  int _waterGoal = 8;
  double _multiplier = 1.0;
  int _sleepStreakDays = 0;
  bool _todayCheckInDone = false;
  int _meditationWeeklyGoal = 5;

  UserProfile? get profile => _profile;
  List<MeditationSession> get meditationSessions => _meditationSessions;
  List<DailyCheckIn> get checkIns => _checkIns;
  List<LocationLog> get locationLogs => _locationLogs;
  List<WellnessData> get wellnessHistory => _wellnessHistory;
  int get totalPoints => _totalPoints;
  int get waterCups => _waterCups;
  int get waterGoal => _waterGoal;
  double get multiplier => _multiplier;
  int get sleepStreakDays => _sleepStreakDays;
  bool get todayCheckInDone => _todayCheckInDone;
  int get meditationWeeklyGoal => _meditationWeeklyGoal;

  String get firstName => _profile?.firstName ?? 'Friend';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final profileJson = prefs.getString('user_profile');
    if (profileJson != null) {
      _profile = UserProfile.fromJson(jsonDecode(profileJson));
    }

    _totalPoints = prefs.getInt('total_points') ?? 420;
    _waterCups = prefs.getInt('water_cups_today') ?? 3;
    _waterGoal = prefs.getInt('water_goal') ?? 8;
    _multiplier = prefs.getDouble('multiplier') ?? 1.0;
    _sleepStreakDays = prefs.getInt('sleep_streak') ?? 0;
    _meditationWeeklyGoal = prefs.getInt('meditation_weekly_goal') ?? 5;

    final todayKey = _todayKey();
    _todayCheckInDone = prefs.getBool('checkin_done_$todayKey') ?? false;

    final sessionsJson = prefs.getString('meditation_sessions');
    if (sessionsJson != null) {
      final list = jsonDecode(sessionsJson) as List;
      _meditationSessions = list
          .map((e) => MeditationSession.fromJson(e))
          .toList();
    }

    final checkInsJson = prefs.getString('daily_checkins');
    if (checkInsJson != null) {
      final list = jsonDecode(checkInsJson) as List;
      _checkIns = list.map((e) => DailyCheckIn.fromJson(e)).toList();
    }

    final logsJson = prefs.getString('location_logs');
    if (logsJson != null) {
      final list = jsonDecode(logsJson) as List;
      _locationLogs = list.map((e) => LocationLog.fromJson(e)).toList();
    }

    final wellnessJson = prefs.getString('wellness_history');
    if (wellnessJson != null) {
      final list = jsonDecode(wellnessJson) as List;
      _wellnessHistory = list.map((e) => WellnessData.fromJson(e)).toList();
    }

    if (_wellnessHistory.isEmpty) {
      _generateSampleData();
    }

    notifyListeners();
  }

  void _generateSampleData() {
    final now = DateTime.now();
    final random = [7.2, 6.5, 8.1, 5.8, 7.5, 6.9, 7.8];
    final water = [6, 8, 5, 7, 8, 6, 7];
    final meditation = [10, 0, 15, 5, 20, 0, 10];
    final hr = [68.0, 72.0, 65.0, 75.0, 67.0, 70.0, 66.0];
    final screen = [4.5, 6.2, 3.8, 5.5, 4.0, 7.1, 3.5];
    final work = [480, 420, 0, 510, 450, 360, 0];
    final rest = [120, 60, 300, 90, 180, 120, 420];
    final burnout = [35.0, 42.0, 28.0, 48.0, 38.0, 45.0, 32.0];
    final pts = [85, 60, 120, 45, 110, 55, 95];

    for (int i = 6; i >= 0; i--) {
      _wellnessHistory.add(
        WellnessData(
          date: now.subtract(Duration(days: i)),
          sleepHours: random[6 - i],
          waterCups: water[6 - i],
          waterGoal: 8,
          meditationMinutes: meditation[6 - i],
          restingHeartRate: hr[6 - i],
          screenTimeHours: screen[6 - i],
          workLocationMinutes: work[6 - i],
          restLocationMinutes: rest[6 - i],
          burnoutScore: burnout[6 - i],
          points: pts[6 - i],
        ),
      );
    }

    // Sample meditation sessions
    _meditationSessions = [
      MeditationSession(
        id: '1',
        date: now.subtract(const Duration(days: 1)),
        durationMinutes: 10,
        moodTag: 'Calm',
        mode: 'free',
      ),
      MeditationSession(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        durationMinutes: 15,
        moodTag: 'Peaceful',
        mode: 'box_breathing',
      ),
      MeditationSession(
        id: '3',
        date: now.subtract(const Duration(days: 4)),
        durationMinutes: 5,
        moodTag: 'Refreshed',
        mode: 'focus_reset',
      ),
      MeditationSession(
        id: '4',
        date: now.subtract(const Duration(days: 6)),
        durationMinutes: 10,
        moodTag: 'Tired',
        mode: 'body_scan',
      ),
    ];
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month}_${now.day}';
  }

  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', jsonEncode(profile.toJson()));
    notifyListeners();
  }

  Future<void> addWater() async {
    if (_waterCups < _waterGoal) {
      _waterCups++;
      _totalPoints += 10;
      if (_waterCups <= 4) {
        _totalPoints += 20; // bonus before noon
      }
    }
    await _savePoints();
    notifyListeners();
  }

  Future<void> setWaterGoal(int goal) async {
    _waterGoal = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('water_goal', goal);
    notifyListeners();
  }

  Future<void> completeCheckIn(DailyCheckIn checkIn) async {
    _checkIns.add(checkIn);
    _todayCheckInDone = true;
    _totalPoints += 15;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checkin_done_${_todayKey()}', true);
    await prefs.setString(
      'daily_checkins',
      jsonEncode(_checkIns.map((e) => e.toJson()).toList()),
    );
    await _savePoints();
    notifyListeners();
  }

  Future<void> addMeditationSession(MeditationSession session) async {
    _meditationSessions.insert(0, session);
    _totalPoints += 35;
    _updateMultiplier();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'meditation_sessions',
      jsonEncode(_meditationSessions.map((e) => e.toJson()).toList()),
    );
    await _savePoints();
    notifyListeners();
  }

  Future<void> setMeditationWeeklyGoal(int goal) async {
    _meditationWeeklyGoal = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('meditation_weekly_goal', goal);
    notifyListeners();
  }

  Future<void> logLocation(String location) async {
    final log = LocationLog(
      timestamp: DateTime.now(),
      location: location,
      minutesSpent: 60,
    );
    _locationLogs.add(log);
    _totalPoints += 15;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'location_logs',
      jsonEncode(_locationLogs.map((e) => e.toJson()).toList()),
    );
    await _savePoints();
    notifyListeners();
  }

  void _updateMultiplier() {
    double m = 1.0;
    if (_sleepStreakDays >= 3) m += 0.5;
    final todayMeditation = _meditationSessions.where((s) {
      final diff = DateTime.now().difference(s.date).inHours;
      return diff < 24;
    }).length;
    if (todayMeditation > 0) m += 0.2;
    _multiplier = m.clamp(1.0, 3.0);
  }

  Future<void> _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_points', _totalPoints);
    await prefs.setInt('water_cups_today', _waterCups);
  }

  double get burnoutScore {
    if (_wellnessHistory.isEmpty) return 30.0;
    final recent = _wellnessHistory.length > 7
        ? _wellnessHistory.sublist(_wellnessHistory.length - 7)
        : _wellnessHistory;

    double score = 0;
    double avgSleep =
        recent.map((d) => d.sleepHours).reduce((a, b) => a + b) / recent.length;
    double avgHR =
        recent.map((d) => d.restingHeartRate).reduce((a, b) => a + b) /
        recent.length;
    double avgScreen =
        recent.map((d) => d.screenTimeHours).reduce((a, b) => a + b) /
        recent.length;
    double avgWater =
        recent.map((d) => d.waterCups / d.waterGoal).reduce((a, b) => a + b) /
        recent.length;
    double avgWork =
        recent
            .map((d) => d.workLocationMinutes / 60.0)
            .reduce((a, b) => a + b) /
        recent.length;
    double avgMeditation =
        recent
            .map((d) => d.meditationMinutes.toDouble())
            .reduce((a, b) => a + b) /
        recent.length;

    // Sleep deficit (target 7.5h)
    score += ((7.5 - avgSleep) * 8).clamp(0, 25);
    // Work hours
    score += (avgWork * 3).clamp(0, 20);
    // Heart rate
    score += ((avgHR - 65) * 0.8).clamp(0, 15);
    // Screen time
    score += ((avgScreen - 4) * 3).clamp(0, 15);
    // Water deficit
    score += ((1 - avgWater) * 10).clamp(0, 10);
    // Meditation reduces score
    score -= (avgMeditation * 0.3).clamp(0, 15);

    // Check-in mood
    if (_checkIns.isNotEmpty) {
      final recentCheckIns = _checkIns.length > 7
          ? _checkIns.sublist(_checkIns.length - 7)
          : _checkIns;
      final negMoods = recentCheckIns
          .where((c) => c.mood == 'Stressed' || c.mood == 'Anxious')
          .length;
      score += negMoods * 3;
    }

    return score.clamp(0, 100);
  }

  String get burnoutLabel {
    final s = burnoutScore;
    if (s <= 25) return 'Thriving';
    if (s <= 50) return 'Balanced';
    if (s <= 70) return 'Fatigued';
    if (s <= 85) return 'Elevated Risk';
    return 'Burnout';
  }

  Color get burnoutColor {
    final s = burnoutScore;
    if (s <= 25) return const Color(0xFF2D6A4F);
    if (s <= 50) return const Color(0xFF5C7A5C);
    if (s <= 70) return const Color(0xFFC4774A);
    if (s <= 85) return const Color(0xFFB85C3A);
    return const Color(0xFF8B2020);
  }

  String get burnoutPrediction {
    if (_wellnessHistory.length < 3) {
      return 'Keep logging your wellness data to see your personalized prediction.';
    }
    final recent = _wellnessHistory.length > 5
        ? _wellnessHistory.sublist(_wellnessHistory.length - 5)
        : _wellnessHistory;
    final scores = recent.map((d) => d.burnoutScore).toList();
    final trend = scores.last - scores.first;

    if (trend < -5) {
      return "You're trending toward a recovery week — keep it up. 🌱";
    } else if (trend > 10) {
      return "At this pace, your burnout score may rise by the weekend. Consider more rest and less screen time.";
    } else {
      return "Your score is holding steady. A little more sleep tonight could tip you toward thriving.";
    }
  }

  double get energyMultiplierProgress {
    return (_multiplier - 1.0) / 2.0;
  }

  int get meditationSessionsThisWeek {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _meditationSessions.where((s) => s.date.isAfter(weekAgo)).length;
  }

  List<LocationLog> get todayLocationLogs {
    final today = DateTime.now();
    return _locationLogs.where((l) {
      return l.timestamp.year == today.year &&
          l.timestamp.month == today.month &&
          l.timestamp.day == today.day;
    }).toList();
  }
}
