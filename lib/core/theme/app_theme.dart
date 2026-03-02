// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Colors ─────────────────────────────────────────────────────────────
  static const Color primary       = Color(0xFF6366F1); // Indigo 500 — slightly brighter
  static const Color primaryDark   = Color(0xFF4F46E5); // Indigo 600
  static const Color accent        = Color(0xFF8B5CF6); // Violet 500
  static const Color accentDark    = Color(0xFF7C3AED); // Violet 600
  static const Color cyan          = Color(0xFF22D3EE); // Cyan 400
  static const Color green         = Color(0xFF10B981); // Emerald 500
  static const Color amber         = Color(0xFFF59E0B); // Amber 500

  // ── Dark Palette (default) ────────────────────────────────────────────────────
  static const Color bgDark        = Color(0xFF08080F); // Near-black
  static const Color surfaceDark   = Color(0xFF0F0F1A); // Dark surface
  static const Color cardDark      = Color(0xFF16162A); // Card bg
  static const Color cardDark2     = Color(0xFF1E1E35); // Elevated card
  static const Color textPrimaryD  = Color(0xFFF0EFFE); // Warm white
  static const Color textSubD      = Color(0xFFB4B4CC); // Muted lavender-grey
  static const Color textHintD     = Color(0xFF6B6B8A); // Faint hint
  static const Color dividerDark   = Color(0xFF252540); // Subtle divider
  static const Color glowPrimary   = Color(0x334F46E5); // Glow overlay

  // ── Light Palette ─────────────────────────────────────────────────────────────
  static const Color bgLight       = Color(0xFFF5F4FF);
  static const Color surfaceLight  = Color(0xFFFFFFFF);
  static const Color cardLight     = Color(0xFFFFFFFF);
  static const Color textPrimaryL  = Color(0xFF1A1840);
  static const Color textSubL      = Color(0xFF5C5C7A);
  static const Color textHintL     = Color(0xFF9CA3B0);
  static const Color dividerLight  = Color(0xFFE8E7FF);

  // ── Spacing / Radius ──────────────────────────────────────────────────────────
  static const double radiusXS = 6.0;
  static const double radiusS  = 10.0;
  static const double radiusM  = 14.0;
  static const double radiusL  = 20.0;
  static const double radiusXL = 28.0;
  static const double radiusXXL= 36.0;

  // ── Shadows ───────────────────────────────────────────────────────────────────
  static List<BoxShadow> get cardShadowDark => [
    BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 6)),
    BoxShadow(color: primary.withOpacity(0.06),     blurRadius: 40, offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> get cardShadowLight => [
    BoxShadow(color: primary.withOpacity(0.10), blurRadius: 24, offset: const Offset(0, 4)),
    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> get buttonGlow => [
    BoxShadow(color: primary.withOpacity(0.45), blurRadius: 20, offset: const Offset(0, 6)),
    BoxShadow(color: accent.withOpacity(0.2),   blurRadius: 40, offset: const Offset(0, 2)),
  ];
  static List<BoxShadow> cardShadow(bool isDark) =>
      isDark ? cardShadowDark : cardShadowLight;

  // ── Gradient helpers ──────────────────────────────────────────────────────────
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient brandGradientV = LinearGradient(
    colors: [primaryDark, accentDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static LinearGradient subtleDarkGradient(Color color) => LinearGradient(
    colors: [color.withOpacity(0.15), color.withOpacity(0.0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Theme builders ────────────────────────────────────────────────────────────
  static ThemeData get lightTheme => _build(false);
  static ThemeData get darkTheme  => _build(true);

  static ThemeData _build(bool dark) {
    final bg         = dark ? bgDark       : bgLight;
    final surface    = dark ? surfaceDark  : surfaceLight;
    final card       = dark ? cardDark     : cardLight;
    final tPrimary   = dark ? textPrimaryD : textPrimaryL;
    final tSub       = dark ? textSubD     : textSubL;
    final tHint      = dark ? textHintD    : textHintL;
    final inputFill  = dark ? cardDark2    : const Color(0xFFF0EFFF);
    final inputBord  = dark ? dividerDark  : dividerLight;

    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: dark ? Brightness.dark : Brightness.light,
        primary: primary,
        secondary: accent,
        tertiary: cyan,
        surface: surface,
        background: bg,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: tPrimary,
        onBackground: tPrimary,
      ),
      scaffoldBackgroundColor: bg,
      textTheme: _buildTextTheme(tPrimary, tSub),
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? bgDark : surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18, fontWeight: FontWeight.w700,
          color: tPrimary, letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: tPrimary),
      ),
      cardTheme: CardThemeData(
  color: card,
  elevation: 0,
  surfaceTintColor: Colors.transparent,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radiusL),
  ),
),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: inputBord, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: tHint),
        labelStyle: GoogleFonts.poppins(fontSize: 13, color: tSub),
        prefixIconColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.focused) ? primary : tHint),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: dark ? surfaceDark : surfaceLight,
        selectedItemColor: primary,
        unselectedItemColor: tHint,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.2,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 10, fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),
      dividerColor: inputBord,
      extensions: [
        AppColors(
          cardBg:      card,
          cardBg2:     dark ? cardDark2 : const Color(0xFFF8F7FF),
          cardShadow:  dark ? cardShadowDark : cardShadowLight,
          textPrimary: tPrimary,
          textSub:     tSub,
          textHint:    tHint,
          inputFill:   inputFill,
          divider:     inputBord,
          isDark:      dark,
        ),
      ],
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color sub) {
    return GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge:  GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w800, color: primary, letterSpacing: -1.0, height: 1.1),
      displayMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.8, height: 1.15),
      headlineLarge: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: primary, letterSpacing: -0.5, height: 1.2),
      headlineMedium:GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: primary, letterSpacing: -0.3, height: 1.25),
      titleLarge:    GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: primary, letterSpacing: -0.2),
      titleMedium:   GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: primary),
      titleSmall:    GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: primary),
      bodyLarge:     GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400, color: sub, height: 1.65),
      bodyMedium:    GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w400, color: sub, height: 1.6),
      bodySmall:     GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: sub, height: 1.5),
      labelLarge:    GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.3),
      labelMedium:   GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: sub),
      labelSmall:    GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: sub, letterSpacing: 0.5),
    );
  }
}

// ── AppColors ThemeExtension ──────────────────────────────────────────────────
class AppColors extends ThemeExtension<AppColors> {
  final Color cardBg;
  final Color cardBg2;
  final List<BoxShadow> cardShadow;
  final Color textPrimary;
  final Color textSub;
  final Color textHint;
  final Color inputFill;
  final Color divider;
  final bool isDark;

  const AppColors({
    required this.cardBg,
    required this.cardBg2,
    required this.cardShadow,
    required this.textPrimary,
    required this.textSub,
    required this.textHint,
    required this.inputFill,
    required this.divider,
    required this.isDark,
  });

  @override
  AppColors copyWith({
    Color? cardBg, Color? cardBg2,
    List<BoxShadow>? cardShadow,
    Color? textPrimary, Color? textSub, Color? textHint,
    Color? inputFill, Color? divider, bool? isDark,
  }) => AppColors(
    cardBg: cardBg ?? this.cardBg,
    cardBg2: cardBg2 ?? this.cardBg2,
    cardShadow: cardShadow ?? this.cardShadow,
    textPrimary: textPrimary ?? this.textPrimary,
    textSub: textSub ?? this.textSub,
    textHint: textHint ?? this.textHint,
    inputFill: inputFill ?? this.inputFill,
    divider: divider ?? this.divider,
    isDark: isDark ?? this.isDark,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      cardBg:      Color.lerp(cardBg,  other.cardBg,  t)!,
      cardBg2:     Color.lerp(cardBg2, other.cardBg2, t)!,
      cardShadow:  t < 0.5 ? cardShadow : other.cardShadow,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSub:     Color.lerp(textSub,     other.textSub,     t)!,
      textHint:    Color.lerp(textHint,    other.textHint,    t)!,
      inputFill:   Color.lerp(inputFill,   other.inputFill,   t)!,
      divider:     Color.lerp(divider,     other.divider,     t)!,
      isDark:      t < 0.5 ? isDark : other.isDark,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}