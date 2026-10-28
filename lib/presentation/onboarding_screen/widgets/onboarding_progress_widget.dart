import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class OnboardingProgressWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgressWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Row(
        children: List.generate(totalSteps, (i) {
          final isActive = i == currentStep;
          final isDone = i < currentStep;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: 4,
                decoration: BoxDecoration(
                  color: isDone
                      ? AppTheme.primary
                      : isActive
                      ? AppTheme.primary.withAlpha(128)
                      : AppTheme.cardBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
