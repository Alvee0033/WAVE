import 'package:flutter/material.dart';
import 'dart:ui';

class AppTheme {
  // Muted color palette for glassmorphism design
  static const Color mutedBlue = Color(0xFF6B7B8C);
  static const Color mutedPurple = Color(0xFF8B7B9C);
  static const Color mutedGray = Color(0xFF4A5568);
  static const Color mutedSlate = Color(0xFF2D3748);
  static const Color mutedWhite = Color(0xFFF7FAFC);
  static const Color mutedDark = Color(0xFF1A202C);
  static const Color mutedDarker = Color(0xFF0F1419);
  
  // Glassmorphism colors
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassDark = Color(0x1A000000);
  static const Color glassBlue = Color(0x1A6B7B8C);
  static const Color glassPurple = Color(0x1A8B7B9C);
  
  // Legacy colors for compatibility
  static const Color primaryColor = mutedBlue;
  static const Color secondaryColor = mutedPurple;
  static const Color backgroundColor = mutedDark;
  static const Color surfaceColor = mutedSlate;
  static const Color textPrimary = mutedWhite;
  static const Color textSecondary = Color(0xFFAAAAAA);
  
  // Accent colors for NASA instruments (muted versions)
  static const Color modisColor = Color(0xFF5A8A5A);
  static const Color asterColor = Color(0xFFB8865A);
  static const Color misrColor = Color(0xFF8A5A8A);
  static const Color ceresColor = Color(0xFFB85A5A);
  static const Color mopittColor = mutedBlue;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      
      colorScheme: const ColorScheme.dark(
        primary: mutedBlue,
        secondary: mutedPurple,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: mutedWhite,
        onSecondary: backgroundColor,
        onBackground: mutedWhite,
        onSurface: mutedWhite,
        outline: mutedGray,
        surfaceVariant: mutedSlate,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: mutedWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: mutedWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: mutedWhite,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: mutedWhite,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: mutedWhite,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: mutedWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: mutedWhite,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: mutedWhite,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textSecondary,
          fontSize: 12,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mutedBlue,
          foregroundColor: mutedWhite,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: mutedBlue,
        foregroundColor: mutedWhite,
      ),
      
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceColor,
        modalBackgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
      ),
      
      sliderTheme: SliderThemeData(
        activeTrackColor: mutedBlue,
        inactiveTrackColor: mutedGray,
        thumbColor: mutedBlue,
        overlayColor: mutedBlue.withOpacity(0.2),
      ),
      
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mutedSlate.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mutedGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mutedGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mutedBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: mutedWhite),
        hintStyle: TextStyle(color: mutedWhite.withOpacity(0.6)),
      ),
    );
  }
  
  // Custom text styles for specific components
  static const TextStyle logoTextStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: mutedWhite,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: mutedBlue,
        offset: Offset(0, 0),
      ),
    ],
  );
  
  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );
  
  // Glassmorphism helper methods
  static BoxDecoration glassmorphismDecoration({
    double opacity = 0.1,
    Color? color,
    double borderRadius = 16,
    double borderWidth = 1,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: (color ?? glassWhite).withOpacity(0.2),
        width: borderWidth,
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          (color ?? glassWhite).withOpacity(opacity),
          glassDark.withOpacity(opacity),
        ],
      ),
    );
  }
  
  static Widget glassmorphismContainer({
    required Widget child,
    double opacity = 0.1,
    Color? color,
    double borderRadius = 16,
    double borderWidth = 1,
    double blurSigma = 10,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding,
      decoration: glassmorphismDecoration(
        opacity: opacity,
        color: color,
        borderRadius: borderRadius,
        borderWidth: borderWidth,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: child,
        ),
      ),
    );
  }
  
  // Gradient backgrounds
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      mutedDark,
      mutedSlate,
      mutedGray,
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      mutedBlue,
      mutedPurple,
    ],
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      mutedSlate,
      mutedGray,
    ],
  );
}