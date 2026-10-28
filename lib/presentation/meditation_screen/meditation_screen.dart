import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../../services/user_profile_service.dart';
import '../../theme/location_theme.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_navigation.dart';

enum MeditationMode { free, boxBreathing, bodyScan, focusReset }

class MeditationScreen extends StatefulWidget {
  final LocationThemeNotifier? themeNotifier;
  const MeditationScreen({super.key, this.themeNotifier});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with TickerProviderStateMixin {
  int _durationMinutes = 10;
  bool _sessionActive = false;
  bool _sessionComplete = false;
  int _secondsRemaining = 0;
  MeditationMode _selectedMode = MeditationMode.free;
  String _selectedMoodTag = '';
  bool _showHistory = false;
  final bool _showGoalEditor = false;
  int _tempWeeklyGoal = 5;

  late AnimationController _rainController;
  late AnimationController _breathController;
  late AnimationController _rippleController;
  late AnimationController _fadeController;
  late AnimationController _boxBreathController;
  late Animation<double> _breathScale;
  late Animation<double> _fadeAnim;

  final List<_RainDrop> _rainDrops = [];
  final math.Random _random = math.Random();
  final _service = UserProfileService();

  static const List<Map<String, dynamic>> _moodTags = [
    {'label': 'Calm', 'emoji': '🌊'},
    {'label': 'Refreshed', 'emoji': '🌿'},
    {'label': 'Distracted', 'emoji': '🍂'},
    {'label': 'Tired', 'emoji': '😴'},
    {'label': 'Peaceful', 'emoji': '☁️'},
  ];

  @override
  void initState() {
    super.initState();
    _tempWeeklyGoal = _service.meditationWeeklyGoal;

    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _boxBreathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _breathScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _generateRainDrops();
  }

  void _generateRainDrops() {
    _rainDrops.clear();
    for (int i = 0; i < 60; i++) {
      _rainDrops.add(
        _RainDrop(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.003 + _random.nextDouble() * 0.004,
          length: 8 + _random.nextDouble() * 12,
          opacity: 0.2 + _random.nextDouble() * 0.4,
        ),
      );
    }
  }

  @override
  void dispose() {
    _rainController.dispose();
    _breathController.dispose();
    _boxBreathController.dispose();
    _rippleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startSession() {
    HapticFeedback.mediumImpact();
    final duration = _getModeDefaultDuration();
    setState(() {
      _sessionActive = true;
      _sessionComplete = false;
      _secondsRemaining = duration * 60;
    });
    _fadeController.forward();
    _rainController.addListener(_updateRain);
    _rainController.repeat();
    _startTimer();
  }

  int _getModeDefaultDuration() {
    switch (_selectedMode) {
      case MeditationMode.boxBreathing:
        return 5;
      case MeditationMode.bodyScan:
        return 10;
      case MeditationMode.focusReset:
        return 5;
      case MeditationMode.free:
        return _durationMinutes;
    }
  }

  void _updateRain() {
    if (!mounted) return;
    setState(() {
      for (final drop in _rainDrops) {
        drop.y += drop.speed;
        if (drop.y > 1.1) {
          drop.y = -0.1;
          drop.x = _random.nextDouble();
        }
      }
    });
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_sessionActive) return false;
      setState(() => _secondsRemaining--);
      if (_secondsRemaining <= 0) {
        _endSession();
        return false;
      }
      return true;
    });
  }

  void _endSession() {
    HapticFeedback.heavyImpact();
    setState(() {
      _sessionActive = false;
      _sessionComplete = true;
    });
    _rainController.stop();
    _fadeController.reverse();
  }

  void _exitSession() {
    if (_sessionActive) {
      setState(() => _sessionActive = false);
      _rainController.stop();
      _fadeController.reverse().then((_) {
        if (mounted) setState(() => _sessionComplete = false);
      });
    }
  }

  Future<void> _saveMoodAndReturn() async {
    final duration = _getModeDefaultDuration();
    final session = MeditationSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      durationMinutes: duration,
      moodTag: _selectedMoodTag.isEmpty ? 'Calm' : _selectedMoodTag,
      mode: _selectedMode.name,
    );
    await _service.addMeditationSession(session);
    if (mounted) {
      setState(() {
        _sessionComplete = false;
        _selectedMoodTag = '';
      });
    }
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get _breathLabel {
    if (_selectedMode == MeditationMode.boxBreathing) {
      final phase = (_boxBreathController.value * 4).floor() % 4;
      switch (phase) {
        case 0:
          return 'Breathe in... (4)';
        case 1:
          return 'Hold... (4)';
        case 2:
          return 'Breathe out... (4)';
        case 3:
          return 'Hold... (4)';
      }
    }
    final phase = _breathController.value;
    if (phase < 0.45) return 'Breathe in...';
    if (phase < 0.55) return 'Hold...';
    return 'Breathe out...';
  }

  Color get _modeAccentColor {
    switch (_selectedMode) {
      case MeditationMode.boxBreathing:
        return const Color(0xFF2A6A7A);
      case MeditationMode.bodyScan:
        return const Color(0xFF5C7A5C);
      case MeditationMode.focusReset:
        return const Color(0xFFC4774A);
      case MeditationMode.free:
        return const Color(0xFF3A6A4A);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionActive) return _buildRainScene();
    if (_sessionComplete) return _buildCompletionScreen();
    return _buildSetupScreen();
  }

  Widget _buildSetupScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2A1A),
      bottomNavigationBar: AppNavigation(
        currentIndex: 1,
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Meditation',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Set your intention, then let the rain carry you.',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _showHistory = !_showHistory),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _showHistory
                              ? Icons.close_rounded
                              : Icons.history_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            // Weekly goal ring
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildWeeklyGoalRing(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            if (_showHistory)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildSessionHistory(),
                ),
              )
            else ...[
              // Mode selector
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildModeSelector(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              // Duration (only for free mode)
              if (_selectedMode == MeditationMode.free)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildDurationSelector(),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _startSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _modeAccentColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.eco_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Begin Session',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyGoalRing() {
    final sessions = _service.meditationSessionsThisWeek;
    final goal = _service.meditationWeeklyGoal;
    final progress = (sessions / goal).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(30)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CustomPaint(
                  painter: _GoalRingPainter(
                    progress: progress,
                    color: _modeAccentColor,
                  ),
                  child: Center(
                    child: Text(
                      '$sessions',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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
                      'Weekly Goal',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$sessions of $goal sessions this week',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 11,
                        color: Colors.white60,
                      ),
                    ),
                    if (sessions >= goal)
                      Text(
                        'Goal reached! 🎉',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF7ABA7A),
                        ),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showGoalEditorSheet(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: Colors.white60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGoalEditorSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A2A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Weekly Meditation Goal',
                style: GoogleFonts.nunitoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_tempWeeklyGoal > 1) {
                        setModal(() => _tempWeeklyGoal--);
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.remove_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    '$_tempWeeklyGoal',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: () {
                      if (_tempWeeklyGoal < 14) {
                        setModal(() => _tempWeeklyGoal++);
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'sessions per week',
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _service.setMeditationWeeklyGoal(_tempWeeklyGoal);
                    if (mounted) {
                      setState(() {});
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _modeAccentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Save Goal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    final modes = [
      {
        'mode': MeditationMode.free,
        'title': 'Free Timer',
        'desc': 'Your own pace',
        'emoji': '🌧️',
        'duration': 'Custom',
      },
      {
        'mode': MeditationMode.boxBreathing,
        'title': 'Box Breathing',
        'desc': '4-4-4-4 pattern',
        'emoji': '📦',
        'duration': '5 min',
      },
      {
        'mode': MeditationMode.bodyScan,
        'title': 'Body Scan',
        'desc': 'Full relaxation',
        'emoji': '🌊',
        'duration': '10 min',
      },
      {
        'mode': MeditationMode.focusReset,
        'title': 'Focus Reset',
        'desc': 'Clear your mind',
        'emoji': '🎯',
        'duration': '5 min',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your practice',
          style: GoogleFonts.nunitoSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white60,
          ),
        ),
        const SizedBox(height: 12),
        ...modes.map((m) {
          final isSelected = _selectedMode == m['mode'];
          return GestureDetector(
            onTap: () =>
                setState(() => _selectedMode = m['mode'] as MeditationMode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? _modeAccentColor.withAlpha(40)
                    : Colors.white.withAlpha(10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? _modeAccentColor
                      : Colors.white.withAlpha(20),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    m['emoji'] as String,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m['title'] as String,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          m['desc'] as String,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 11,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      m['duration'] as String,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 10,
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      children: [
        Text(
          'Duration',
          style: GoogleFonts.nunitoSans(
            fontSize: 13,
            color: Colors.white54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _DurationButton(
              icon: Icons.remove_rounded,
              onTap: () {
                if (_durationMinutes > 1) setState(() => _durationMinutes--);
              },
            ),
            const SizedBox(width: 24),
            Column(
              children: [
                Text(
                  '$_durationMinutes',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 56,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Text(
                  'minutes',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            _DurationButton(
              icon: Icons.add_rounded,
              onTap: () {
                if (_durationMinutes < 60) setState(() => _durationMinutes++);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [5, 10, 15, 20, 30].map((min) {
            final isSelected = _durationMinutes == min;
            return GestureDetector(
              onTap: () => setState(() => _durationMinutes = min),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withAlpha(40)
                      : Colors.white.withAlpha(10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white54
                        : Colors.white.withAlpha(20),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  '${min}m',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.white54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSessionHistory() {
    final sessions = _service.meditationSessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session History',
          style: GoogleFonts.nunitoSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        if (sessions.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'No sessions yet — start your first one below.',
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  color: Colors.white54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ...sessions.take(10).map((s) => _buildSessionTile(s)),
      ],
    );
  }

  Widget _buildSessionTile(MeditationSession session) {
    final moodEmoji =
        _moodTags.firstWhere(
              (m) => m['label'] == session.moodTag,
              orElse: () => {'emoji': '🌿'},
            )['emoji']
            as String;

    final modeLabel =
        {
          'free': 'Free Timer',
          'boxBreathing': 'Box Breathing',
          'bodyScan': 'Body Scan',
          'focusReset': 'Focus Reset',
        }[session.mode] ??
        'Free Timer';

    final dateStr = _formatDate(session.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Row(
        children: [
          Text(moodEmoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modeLabel,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$dateStr · ${session.durationMinutes} min',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              session.moodTag,
              style: GoogleFonts.nunitoSans(
                fontSize: 10,
                color: Colors.white60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }

  Widget _buildRainScene() {
    return GestureDetector(
      onTap: _exitSession,
      child: Scaffold(
        backgroundColor: _getRainBgColor(),
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _rainController,
              builder: (context, _) => CustomPaint(
                painter: _RainPainter(drops: _rainDrops),
                size: Size.infinite,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _rippleController,
                builder: (context, _) => CustomPaint(
                  painter: _RipplePainter(phase: _rippleController.value),
                  size: const Size(double.infinity, 80),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _breathController,
                    builder: (context, _) => Column(
                      children: [
                        Container(
                          width: 160 * (0.8 + _breathScale.value * 0.3),
                          height: 160 * (0.8 + _breathScale.value * 0.3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withAlpha(
                                (30 * _breathScale.value).toInt(),
                              ),
                              width: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _breathController,
                    builder: (context, _) => Transform.scale(
                      scale: _breathScale.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _modeAccentColor.withAlpha(180),
                          boxShadow: [
                            BoxShadow(
                              color: _modeAccentColor.withAlpha(
                                (80 * _breathScale.value).toInt(),
                              ),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.eco_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _breathController,
                    builder: (context, _) => Text(
                      _breathLabel,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    _formatTime(_secondsRemaining),
                    style: GoogleFonts.nunitoSans(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withAlpha(200),
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap anywhere to exit',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 11,
                      color: Colors.white30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRainBgColor() {
    switch (_selectedMode) {
      case MeditationMode.boxBreathing:
        return const Color(0xFF0D1A2A);
      case MeditationMode.bodyScan:
        return const Color(0xFF0D1A14);
      case MeditationMode.focusReset:
        return const Color(0xFF1A1208);
      case MeditationMode.free:
        return const Color(0xFF0D1A14);
    }
  }

  Widget _buildCompletionScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1A14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🌿', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 24),
              Text(
                'Session complete',
                style: GoogleFonts.nunitoSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'How do you feel?',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _moodTags.map((m) {
                  final isSelected = _selectedMoodTag == m['label'];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedMoodTag = m['label'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withAlpha(40)
                            : Colors.white.withAlpha(10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.white54
                              : Colors.white.withAlpha(20),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            m['emoji'] as String,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            m['label'] as String,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveMoodAndReturn();
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.homeScreen,
                        (r) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _modeAccentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Return to Root',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _GoalRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final bgPaint = Paint()
      ..color = Colors.white.withAlpha(20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_GoalRingPainter old) => old.progress != progress;
}

class _DurationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DurationButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white70, size: 22),
      ),
    );
  }
}

class _RainDrop {
  double x;
  double y;
  final double speed;
  final double length;
  final double opacity;

  _RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
    required this.opacity,
  });
}

class _RainPainter extends CustomPainter {
  final List<_RainDrop> drops;

  _RainPainter({required this.drops});

  @override
  void paint(Canvas canvas, Size size) {
    for (final drop in drops) {
      final paint = Paint()
        ..color = Colors.lightBlue.withAlpha((drop.opacity * 255).toInt())
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round;
      final x = drop.x * size.width;
      final y = drop.y * size.height;
      canvas.drawLine(Offset(x, y), Offset(x - 2, y + drop.length), paint);
    }
  }

  @override
  bool shouldRepaint(_RainPainter old) => true;
}

class _RipplePainter extends CustomPainter {
  final double phase;

  _RipplePainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 3; i++) {
      final ripplePhase = (phase + i * 0.33) % 1.0;
      final paint = Paint()
        ..color = Colors.lightBlue.withAlpha((30 * (1 - ripplePhase)).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      final centerX = size.width * (0.2 + i * 0.3);
      final radius = 10 + ripplePhase * 30;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, 20),
          width: radius * 2,
          height: radius * 0.4,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.phase != phase;
}
