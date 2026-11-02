import 'package:flutter/material.dart';

/// Civil Engineering Theme System (Silver / Slate / Steel)
/// Specified for ICEC 2026 GFRP Beam Capacity Analyzer.
class AppTheme {
  AppTheme._();

  // Core Palette
  static const Color scaffoldBackground = Color(0xFFF1F5F9); // Light metallic silver-gray
  static const Color cardBackground = Color(0xFFFFFFFF);     // Crisp white surface
  static const Color cardBorder = Color(0xFFCBD5E1);         // Subtle silver border
  static const Color lightSurface = Color(0xFFF8FAFC);       // Very light slate tint

  // Steel & Slate Hierarchy
  static const Color primarySteel = Color(0xFF1E293B);       // Deep slate steel header/text
  static const Color secondarySteel = Color(0xFF334155);     // Medium slate steel
  static const Color mutedSlate = Color(0xFF64748B);         // Subdued slate gray for captions
  static const Color borderSlate = Color(0xFFE2E8F0);        // Input borders & dividers

  // Accent & Action
  static const Color accentBlue = Color(0xFF0284C7);         // Blueprint / Steel Blue
  static const Color accentBlueHover = Color(0xFF0369A1);    // Darker Blueprint Blue
  static const Color accentBlueLight = Color(0xFFE0F2FE);    // Subtle blueprint tint for badges
  static const Color accentBlueBorder = Color(0xFFBAE6FD);

  // Status & Behavior Colors
  // 🟢 Safe / Preferred: Concrete Crushing (Ductile)
  static const Color crushingGreen = Color(0xFF10B981);       // Emerald
  static const Color crushingGreenBg = Color(0xFFECFDF5);     // Light emerald background
  static const Color crushingGreenBorder = Color(0xFFA7F3D0);

  // 🟠 Warning / Brittle: GFRP Rupture (Tension-Controlled Risk)
  static const Color ruptureAmber = Color(0xFFF59E0B);        // Amber
  static const Color ruptureAmberBg = Color(0xFFFFFBEB);      // Light amber background
  static const Color ruptureAmberBorder = Color(0xFFFDE68A);

  // 🔴 Constructability Hazard / Spacing Fail
  static const Color hazardRose = Color(0xFFEF4444);          // Rose / Crimson
  static const Color hazardRoseBg = Color(0xFFFEF2F2);        // Light rose background
  static const Color hazardRoseBorder = Color(0xFFFECACA);

  /// Standard Box Shadow for Engineering Cards
  static List<BoxShadow> get cardShadow => [
        const BoxShadow(
          color: Color(0x0A0F172A), // 4% opacity slate
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ];

  /// Standard Box Decoration for Cards
  static BoxDecoration cardDecoration({
    Color background = cardBackground,
    Color borderColor = cardBorder,
    double radius = 12.0,
  }) {
    return BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: 1.0),
      boxShadow: cardShadow,
    );
  }

  /// ThemeData for MaterialApp
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentBlue,
        primary: accentBlue,
        surface: cardBackground,
        onSurface: primarySteel,
      ),
      fontFamily: 'Segoe UI',
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: cardBorder, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        labelStyle: const TextStyle(
          color: secondarySteel,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(color: mutedSlate, fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderSlate, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderSlate, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentBlue, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: hazardRose, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: hazardRose, width: 1.8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: Colors.white,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: accentBlue,
        inactiveTrackColor: borderSlate,
        thumbColor: accentBlue,
        overlayColor: accentBlue.withValues(alpha: 0.15),
        trackHeight: 3.5,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
      ),
    );
  }
}
