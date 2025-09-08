import 'package:flutter/material.dart';
import 'dart:ui';

class AppTheme {
  // Modern White Theme Colors
  static const Color primaryColor = Color(0xFF2563EB); // Blue-600
  static const Color secondaryColor = Color(0xFF7C3AED); // Violet-600
  static const Color backgroundColor = Color(0xFFFAFAFA); // Gray-50
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF111827); // Gray-900
  static const Color textSecondaryColor = Color(0xFF6B7280); // Gray-500
  static const Color accentColor = Color(0xFF10B981); // Emerald-500
  static const Color errorColor = Color(0xFFEF4444); // Red-500
  static const Color successColor = Color(0xFF10B981); // Emerald-500
  static const Color warningColor = Color(0xFFF59E0B); // Amber-500
  static const Color infoColor = Color(0xFF3B82F6); // Blue-500
  static const Color borderColor = Color(0xFFE5E7EB); // Gray-200
  static const Color shadowColor = Color(0x1A000000); // Black with 10% opacity
  
  // Sidebar colors
  static const Color sidebarColor = Color(0xFFF8FAFC); // Gray-50
  static const Color sidebarSelectedColor = Color(0xFFEBF4FF); // Blue-50
  static const Color sidebarHoverColor = Color(0xFFF1F5F9); // Gray-100
  
  // Accent colors for NASA instruments
  static const Color modisColor = Color(0xFF10B981); // Emerald-500
  static const Color asterColor = Color(0xFFF59E0B); // Amber-500
  static const Color misrColor = Color(0xFF8B5CF6); // Violet-500
  static const Color ceresColor = Color(0xFFEF4444); // Red-500
  static const Color mopittColor = Color(0xFF3B82F6); // Blue-500

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        onSurface: textPrimaryColor,
        surfaceContainerHighest: cardColor,
        error: errorColor,
        onError: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        background: backgroundColor,
        onBackground: textPrimaryColor,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondaryColor,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textSecondaryColor,
          fontSize: 12,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
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
        activeTrackColor: primaryColor,
        inactiveTrackColor: borderColor,
        thumbColor: primaryColor,
        overlayColor: primaryColor.withOpacity(0.2),
      ),
      
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor, width: 1),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondaryColor),
        hintStyle: const TextStyle(color: textSecondaryColor),
      ),
      
      drawerTheme: const DrawerThemeData(
        backgroundColor: surfaceColor,
        elevation: 0,
      ),
      
      listTileTheme: const ListTileThemeData(
        textColor: textPrimaryColor,
        iconColor: textSecondaryColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
  
  // Custom text styles for specific components
  static const TextStyle logoTextStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: primaryColor,
        offset: Offset(0, 0),
      ),
    ],
  );
  
  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 14,
    color: textSecondaryColor,
  );
  
  // Modern card decoration
  static BoxDecoration modernCardDecoration({
    double borderRadius = 16,
    Color? color,
    double elevation = 2,
  }) {
    return BoxDecoration(
      color: color ?? cardColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: 1),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          blurRadius: elevation * 4,
          offset: Offset(0, elevation * 2),
        ),
      ],
    );
  }
  
  // Sidebar item decoration
  static BoxDecoration sidebarItemDecoration({
    bool isSelected = false,
    bool isHovered = false,
  }) {
    Color backgroundColor = sidebarColor;
    if (isSelected) {
      backgroundColor = sidebarSelectedColor;
    } else if (isHovered) {
      backgroundColor = sidebarHoverColor;
    }
    
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: isSelected 
        ? Border.all(color: primaryColor.withOpacity(0.3), width: 1)
        : null,
    );
  }
  
  // Gradient backgrounds
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryColor,
      secondaryColor,
    ],
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      backgroundColor,
      surfaceColor,
    ],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accentColor,
      successColor,
    ],
  );
}