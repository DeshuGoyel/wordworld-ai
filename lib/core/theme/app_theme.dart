import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary palette - vibrant and kid-friendly
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFFA29BFE);
  static const Color primaryDark = Color(0xFF4834D4);

  // Secondary
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryLight = Color(0xFFFF8787);
  static const Color secondaryDark = Color(0xFFEE5A24);

  // Accent colors
  static const Color accent1 = Color(0xFFFFC312); // Yellow/Gold
  static const Color accent2 = Color(0xFF00D2D3); // Teal
  static const Color accent3 = Color(0xFF1DD1A1); // Green
  static const Color accent4 = Color(0xFFFF9FF3); // Pink

  // Backgrounds
  static const Color bgLight = Color(0xFFF8F9FE);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgDark = Color(0xFF2C3E50);
  static const Color darkBg = Color(0xFF1A1A2E);   // Dark splash/premium bg
  static const Color darkBg2 = Color(0xFF16213E);  // Slightly lighter dark

  // Text
  static const Color textDark = Color(0xFF2D3436);
  static const Color textMedium = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFD63031);
  static const Color info = Color(0xFF0984E3);

  // Star colors
  static const Color starActive = Color(0xFFFFC312);
  static const Color starInactive = Color(0xFFDFE6E9);

  // ═══════════ SUBJECT WORLD COLORS ═══════════
  static const Color languageWorld = Color(0xFF6C5CE7);   // Purple
  static const Color mathWorld = Color(0xFF0984E3);       // Blue
  static const Color evsWorld = Color(0xFF00B894);        // Green
  static const Color valuesWorld = Color(0xFFFF9F43);     // Orange
  static const Color codingWorld = Color(0xFF00CEC9);     // Teal (v2)
  static const Color artWorld = Color(0xFFFF6B9D);        // Pink (v2)

  // ═══════════ GRAMMAR CHARACTER COLORS ═══════════
  static const Color noraNoun = Color(0xFF00B894);        // Green
  static const Color veraVerb = Color(0xFFFF6B6B);        // Red
  static const Color adaAdjective = Color(0xFF6C5CE7);    // Purple
  static const Color petePresent = Color(0xFF1DD1A1);     // Bright green
  static const Color pattyPast = Color(0xFF74B9FF);       // Soft blue
  static const Color fredFuture = Color(0xFFFF9F43);      // Orange
  // Aliases used in grammar module screens
  static const Color petePre = petePresent;
  static const Color pattyPro = pattyPast;
  static const Color fredFull = fredFuture;

  // ═══════════ EMOTION CHARACTER COLORS ═══════════
  static const Color happyHana = Color(0xFFFFC312);       // Yellow
  static const Color sadSam = Color(0xFF74B9FF);          // Blue
  static const Color angryAnu = Color(0xFFFF4757);        // Red
  static const Color scaredSara = Color(0xFFA29BFE);      // Purple
  static const Color proudPriya = Color(0xFFFFA502);      // Gold

  // ═══════════ XP/STREAK/GAME COLORS ═══════════
  static const Color xpPurple = Color(0xFF6C5CE7);
  static const Color xpPink = Color(0xFFFF6B9D);
  static const Color streakOrange = Color(0xFFFF9F43);
  static const Color heartRed = Color(0xFFFF4757);
  static const Color lockedGrey = Color(0xFFB2BEC3);
  static const Color proBadge = Color(0xFFFFC312);

  // Letter colors - each letter gets a unique vibrant color
  static const Map<String, Color> letterColors = {
    'A': Color(0xFFFF6B6B), 'B': Color(0xFF6C5CE7), 'C': Color(0xFFFF9FF3),
    'D': Color(0xFF00D2D3), 'E': Color(0xFF1DD1A1), 'F': Color(0xFFFFA502),
    'G': Color(0xFFFF4757), 'H': Color(0xFF5352ED), 'I': Color(0xFFE17055),
    'J': Color(0xFF00CEC9), 'K': Color(0xFFFD79A8), 'L': Color(0xFF55A3F5),
    'M': Color(0xFF6C5CE7), 'N': Color(0xFFE84393), 'O': Color(0xFFFF7675),
    'P': Color(0xFF0984E3), 'Q': Color(0xFFD63031), 'R': Color(0xFF00B894),
    'S': Color(0xFFFDCB6E), 'T': Color(0xFFE17055), 'U': Color(0xFF74B9FF),
    'V': Color(0xFFA29BFE), 'W': Color(0xFF55EFC4), 'X': Color(0xFFFF6348),
    'Y': Color(0xFFFFC312), 'Z': Color(0xFF2ED573),
  };

  // Tab colors
  static const Color meetTab = Color(0xFFFF6B6B);
  static const Color thinkTab = Color(0xFF6C5CE7);
  static const Color talkTab = Color(0xFF00D2D3);
  static const Color writeTab = Color(0xFF1DD1A1);
  static const Color drawTab = Color(0xFFFFA502);
  static const Color storyTab = Color(0xFFFF9FF3);
}

/// Font family references
class AppFonts {
  static const String heading = 'Nunito';  // Using bundled Nunito for headings
  static const String body = 'Nunito';     // Using bundled Nunito for body
  // Google Fonts fallbacks
  static TextStyle headingStyle({double size = 28, FontWeight weight = FontWeight.w800, Color color = AppColors.textDark}) {
    return GoogleFonts.nunito(fontSize: size, fontWeight: weight, color: color);
  }
  static TextStyle bodyStyle({double size = 16, FontWeight weight = FontWeight.w400, Color color = AppColors.textDark}) {
    return GoogleFonts.nunito(fontSize: size, fontWeight: weight, color: color);
  }
  static TextStyle labelStyle({double size = 14, FontWeight weight = FontWeight.w700, Color color = AppColors.textMedium}) {
    return GoogleFonts.nunito(fontSize: size, fontWeight: weight, color: color);
  }
}

/// Gradient presets used across the app
class AppGradients {
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient warm = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFA502)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient cool = LinearGradient(
    colors: [Color(0xFF00D2D3), Color(0xFF0984E3)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient nature = LinearGradient(
    colors: [Color(0xFF1DD1A1), Color(0xFF00B894)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient sunset = LinearGradient(
    colors: [Color(0xFFFF9FF3), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient gold = LinearGradient(
    colors: [Color(0xFFFFC312), Color(0xFFFFA502)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  // ═══════════ NEW GRADIENTS ═══════════
  static const LinearGradient darkSplash = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF6C5CE7)],
    begin: Alignment.topCenter, end: Alignment.bottomCenter,
  );
  static const LinearGradient pinkPurple = LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFF6C5CE7)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient xpBar = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFFFF6B9D)],
    begin: Alignment.centerLeft, end: Alignment.centerRight,
  );

  // Subject world gradients
  static const LinearGradient language = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient math = LinearGradient(
    colors: [Color(0xFF0984E3), Color(0xFF74B9FF)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient evs = LinearGradient(
    colors: [Color(0xFF00B894), Color(0xFF1DD1A1)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient values = LinearGradient(
    colors: [Color(0xFFFF9F43), Color(0xFFFFC312)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient coding = LinearGradient(
    colors: [Color(0xFF00CEC9), Color(0xFF00D2D3)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const LinearGradient art = LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFFF9FF3)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static LinearGradient forLetter(String letter) {
    final color = AppColors.letterColors[letter] ?? AppColors.primary;
    return LinearGradient(
      colors: [color, color.withValues(alpha: 0.7)],
      begin: Alignment.topLeft, end: Alignment.bottomRight,
    );
  }
}

/// Shadow presets
class AppShadows {
  static List<BoxShadow> soft(Color color) => [
    BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4)),
  ];
  static List<BoxShadow> medium(Color color) => [
    BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6)),
  ];
  static List<BoxShadow> strong(Color color) => [
    BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 8)),
  ];
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x12000000), blurRadius: 12, offset: Offset(0, 4)),
  ];
  // Duolingo 3D button bottom shadow
  static List<BoxShadow> button3D(Color color) => [
    BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 0, offset: const Offset(0, 4)),
  ];
  // Glow shadow for XP/streak/AI elements
  static List<BoxShadow> glow(Color color) => [
    BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2),
  ];
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double full = 999;
}

/// Animation duration presets
class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration entrance = Duration(milliseconds: 600);
  static const Duration celebration = Duration(milliseconds: 1200);
}

/// XP level definitions
class AppLevels {
  static const List<({String name, String emoji, int minXP})> levels = [
    (name: 'Seedling', emoji: '🌱', minXP: 0),
    (name: 'Explorer', emoji: '🔍', minXP: 100),
    (name: 'Learner', emoji: '📚', minXP: 300),
    (name: 'Achiever', emoji: '⭐', minXP: 600),
    (name: 'Master', emoji: '🏆', minXP: 1000),
    (name: 'Champion', emoji: '🌟', minXP: 1500),
  ];

  static ({String name, String emoji, int minXP}) forXP(int xp) {
    for (int i = levels.length - 1; i >= 0; i--) {
      if (xp >= levels[i].minXP) return levels[i];
    }
    return levels[0];
  }

  static double progressToNext(int xp) {
    final current = forXP(xp);
    final currentIdx = levels.indexWhere((l) => l.minXP == current.minXP);
    if (currentIdx >= levels.length - 1) return 1.0;
    final next = levels[currentIdx + 1];
    return (xp - current.minXP) / (next.minXP - current.minXP);
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.nunitoTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.bgLight,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(fontSize: 40, fontWeight: FontWeight.w800, color: AppColors.textDark),
        displayMedium: textTheme.displayMedium?.copyWith(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textDark),
        headlineLarge: textTheme.headlineLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textDark),
        headlineMedium: textTheme.headlineMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textDark),
        titleLarge: textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textDark),
        titleMedium: textTheme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textDark),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textMedium),
        labelLarge: textTheme.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textWhite),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.textDark,
        titleTextStyle: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
          textStyle: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard, elevation: 4,
        shadowColor: AppColors.primary.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDark,
    );
  }
}
