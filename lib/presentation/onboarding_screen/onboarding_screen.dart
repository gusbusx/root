import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../services/user_profile_service.dart';
import '../../theme/app_theme.dart';
import './widgets/onboarding_header_widget.dart';
import './widgets/onboarding_progress_widget.dart';
import './widgets/onboarding_step_activity_widget.dart';
import './widgets/onboarding_step_details_widget.dart';
import './widgets/onboarding_step_health_widget.dart';
import './widgets/onboarding_step_occupation_widget.dart';
import './widgets/onboarding_step_profile_widget.dart';
import './widgets/onboarding_step_welcome_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  final int _totalSteps = 6;

  String _userName = '';
  String _profileType = '';
  int _age = 0;
  bool _inSchool = false;
  bool _playsSports = false;
  List<String> _healthConditions = [];
  String _occupation = '';

  late AnimationController _stepController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _stepController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = CurvedAnimation(
      parent: _stepController,
      curve: Curves.easeOut,
    );
    _stepController.forward();
  }

  @override
  void dispose() {
    _stepController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _stepController.reset();
      setState(() => _currentStep++);
      _stepController.forward();
    } else {
      _finishOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _stepController.reset();
      setState(() => _currentStep--);
      _stepController.forward();
    }
  }

  Future<void> _finishOnboarding() async {
    final profile = UserProfile(
      firstName: _userName.trim(),
      age: _age,
      occupation: _occupation,
      profileType: _profileType,
      inSchool: _inSchool,
      playsSports: _playsSports,
      healthConditions: _healthConditions,
      locationTrackingMode: 'manual',
    );
    await UserProfileService().saveProfile(profile);
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.locationSelectorScreen,
        (route) => false,
      );
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _userName.trim().isNotEmpty;
      case 1:
        return _profileType.isNotEmpty;
      case 2:
        return _occupation.isNotEmpty;
      case 3:
        return _age >= 13 && _age <= 99;
      case 4:
        return true;
      case 5:
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 520 : double.infinity,
            ),
            child: Column(
              children: [
                OnboardingHeaderWidget(currentStep: _currentStep),
                OnboardingProgressWidget(
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                ),
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildCurrentStep(),
                    ),
                  ),
                ),
                _buildNavigationButtons(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return OnboardingStepWelcomeWidget(
          userName: _userName,
          onNameChanged: (v) => setState(() => _userName = v),
        );
      case 1:
        return OnboardingStepProfileWidget(
          selectedProfile: _profileType,
          onProfileSelected: (v) => setState(() => _profileType = v),
        );
      case 2:
        return OnboardingStepOccupationWidget(
          selectedOccupation: _occupation,
          onOccupationSelected: (v) => setState(() => _occupation = v),
        );
      case 3:
        return OnboardingStepDetailsWidget(
          age: _age,
          inSchool: _inSchool,
          onAgeChanged: (v) => setState(() => _age = v),
          onInSchoolChanged: (v) => setState(() => _inSchool = v),
        );
      case 4:
        return OnboardingStepActivityWidget(
          playsSports: _playsSports,
          profileType: _profileType,
          onPlaysSportsChanged: (v) => setState(() => _playsSports = v),
        );
      case 5:
        return OnboardingStepHealthWidget(
          selectedConditions: _healthConditions,
          onConditionsChanged: (v) => setState(() => _healthConditions = v),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildNavigationButtons() {
    final isLast = _currentStep == _totalSteps - 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: _currentStep == 0 ? 1 : 2,
            child: AnimatedOpacity(
              opacity: _canProceed() ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: _canProceed() ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLast
                      ? AppTheme.secondary
                      : AppTheme.primary,
                ),
                child: Text(isLast ? 'Plant My Seed 🌱' : 'Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
