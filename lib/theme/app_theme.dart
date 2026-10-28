import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Root — Earthy Wellness Palette
  static const Color primary = Color(0xFF5C7A5C); // sage green
  static const Color primaryLight = Color(0xFF7A9E7A);
  static const Color primaryDark = Color(0xFF3D5A3E);
  static const Color secondary = Color(0xFFC4774A); // terracotta
  static const Color secondaryLight = Color(0xFFD9956A);
  static const Color waterBlue = Color(0xFF6BA3BE);
  static const Color waterBlueDark = Color(0xFF4A82A0);
  static const Color focusModeTint = Color(0xFF3D5A3E);
  static const Color restModeTint = Color(0xFF4A7A6A);
  static const Color homeModeTint = Color(0xFF8B6F47);

  static const Color surface = Color(0xFFFAF7F2); // warm cream
  static const Color surfaceVariant = Color(0xFFF2EDE4); // warm beige
  static const Color background = Color(0xFFFAF7F2);
  static const Color cardBorder = Color(0xFFE0D8CC);
  static const Color muted = Color(0xFF9E9E85);
  static const Color mutedLight = Color(0xFFBFB9AD);

  static const Color success = Color(0xFF4A7C59);
  static const Color warning = Color(0xFFC4774A);
  static const Color error = Color(0xFFB85C5C);

  // Dark equivalents
  static const Color darkSurface = Color(0xFF1E2420);
  static const Color darkSurfaceVariant = Color(0xFF2A302C);
  static const Color darkBackground = Color(0xFF161B18);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFD4E8D4),
        onPrimaryContainer: primaryDark,
        secondary: secondary,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFEDD5C4),
        onSecondaryContainer: Color(0xFF6B3B1E),
        surface: surface,
        onSurface: Color(0xFF2C2C1E),
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: Color(0xFF5A5A4A),
        outline: cardBorder,
        outlineVariant: Color(0xFFECE6DC),
        error: error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.nunitoSansTextTheme().copyWith(
        displayLarge: GoogleFonts.nunitoSans(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2C2C1E),
        ),
        displayMedium: GoogleFonts.nunitoSans(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2C2C1E),
        ),
        headlineLarge: GoogleFonts.nunitoSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2C2C1E),
        ),
        headlineMedium: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C2C1E),
        ),
        headlineSmall: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C2C1E),
        ),
        titleLarge: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C2C1E),
        ),
        titleMedium: GoogleFonts.nunitoSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C2C1E),
        ),
        titleSmall: GoogleFonts.nunitoSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C2C1E),
        ),
        bodyLarge: GoogleFonts.nunitoSans(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xFF2C2C1E),
        ),
        bodyMedium: GoogleFonts.nunitoSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Color(0xFF5A5A4A),
        ),
        bodySmall: GoogleFonts.nunitoSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9E9E85),
        ),
        labelLarge: GoogleFonts.nunitoSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        labelMedium: GoogleFonts.nunitoSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelSmall: GoogleFonts.nunitoSans(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.nunitoSans(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C2C1E),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cardBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: cardBorder, width: 1.5),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: cardBorder, width: 1.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primary, width: 2),
        ),
        labelStyle: GoogleFonts.nunitoSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: muted,
        ),
        hintStyle: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: mutedLight,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        height: 64,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryLight,
        onPrimary: darkBackground,
        primaryContainer: primaryDark,
        onPrimaryContainer: Color(0xFFD4E8D4),
        secondary: secondaryLight,
        onSecondary: darkBackground,
        surface: darkSurface,
        onSurface: Color(0xFFE8E4DC),
        surfaceContainerHighest: darkSurfaceVariant,
        onSurfaceVariant: Color(0xFFBFB9AD),
        outline: Color(0xFF4A4A3A),
        outlineVariant: Color(0xFF3A3A2C),
        error: Color(0xFFCF8080),
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: GoogleFonts.nunitoSansTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.nunitoSans(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE8E4DC),
            ),
            headlineLarge: GoogleFonts.nunitoSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE8E4DC),
            ),
            titleMedium: GoogleFonts.nunitoSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE8E4DC),
            ),
            bodyMedium: GoogleFonts.nunitoSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFFBFB9AD),
            ),
            bodySmall: GoogleFonts.nunitoSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9E9E85),
            ),
          ),
    );
  }
}
