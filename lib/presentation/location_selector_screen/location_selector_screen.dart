import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import '../../theme/app_theme.dart';
import '../../theme/location_theme.dart';
import '../../routes/app_routes.dart';

class LocationSelectorScreen extends StatefulWidget {
  final LocationThemeNotifier themeNotifier;
  const LocationSelectorScreen({super.key, required this.themeNotifier});

  @override
  State<LocationSelectorScreen> createState() => _LocationSelectorScreenState();
}

class _LocationSelectorScreenState extends State<LocationSelectorScreen>
    with TickerProviderStateMixin {
  LocationType? _selected;
  late AnimationController _bgController;
  late AnimationController _cardsController;
  late AnimationController _ambientController;
  late Animation<double> _bgFade;
  late Animation<double> _cardsFade;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _bgFade = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeOutCubic,
    );
    _cardsFade = CurvedAnimation(
      parent: _cardsController,
      curve: Curves.easeOutCubic,
    );
    _cardsController.forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _cardsController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  void _selectLocation(LocationType type) {
    HapticFeedback.mediumImpact();
    setState(() => _selected = type);
    widget.themeNotifier.select(type);
    _bgController.reset();
    _bgController.forward();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeScreen,
          (route) => false,
        );
      }
    });
  }

  Color get _bgColor {
    if (_selected == null) return AppTheme.background;
    return LocationTheme.fromType(_selected!).backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      color: _bgColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FadeTransition(
            opacity: _cardsFade,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ambient animated header
                  AnimatedBuilder(
                    animation: _ambientController,
                    builder: (context, _) {
                      return _buildHeader();
                    },
                  ),
                  const SizedBox(height: 40),
                  // Location grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                    itemCount: LocationTheme.all.length,
                    itemBuilder: (context, i) {
                      final loc = LocationTheme.all[i];
                      final isSelected = _selected == loc.type;
                      return _LocationCard(
                        data: loc,
                        isSelected: isSelected,
                        onTap: () => _selectLocation(loc.type),
                        ambientValue: _ambientController.value,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'You can change this anytime',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        color: AppTheme.muted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final wave = math.sin(_ambientController.value * math.pi * 2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: Offset(0, wave * 2),
          child: Text(
            'Where are you\nright now?',
            style: GoogleFonts.nunitoSans(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: _selected != null
                  ? LocationTheme.fromType(_selected!).primaryColor
                  : AppTheme.primaryDark,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Root adapts its whole vibe to match your environment.',
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            color: AppTheme.muted,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _LocationCard extends StatefulWidget {
  final LocationThemeData data;
  final bool isSelected;
  final VoidCallback onTap;
  final double ambientValue;

  const _LocationCard({
    required this.data,
    required this.isSelected,
    required this.onTap,
    required this.ambientValue,
  });

  @override
  State<_LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<_LocationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wave = math.sin(
      widget.ambientValue * math.pi * 2 + widget.data.type.index * 0.8,
    );

    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.data.primaryColor.withAlpha(30)
                : AppTheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isSelected
                  ? widget.data.primaryColor
                  : AppTheme.cardBorder,
              width: widget.isSelected ? 2.5 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.data.primaryColor.withAlpha(40),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, wave * 3),
                child: Text(
                  widget.data.emoji,
                  style: TextStyle(fontSize: widget.isSelected ? 40 : 36),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.data.label,
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: widget.isSelected
                      ? widget.data.primaryColor
                      : AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.data.description,
                style: GoogleFonts.nunitoSans(
                  fontSize: 10,
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
