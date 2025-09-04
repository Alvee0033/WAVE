import 'package:flutter/material.dart';
import '../theme/app_constants.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppConstants.mobileBreakpoint && 
           width < AppConstants.tabletBreakpoint;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.tabletBreakpoint;
  }
  
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  
  static EdgeInsets getScreenPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(AppConstants.spacingL);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(AppConstants.spacingXL);
    } else {
      return const EdgeInsets.all(AppConstants.spacingXXL);
    }
  }
  
  static double getGlobeSize(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isMobile(context)) {
      return screenWidth * 0.8;
    } else if (isTablet(context)) {
      return screenWidth * 0.6;
    } else {
      return AppConstants.globeSize;
    }
  }
  
  static double getFontSize(BuildContext context, double baseFontSize) {
    if (isMobile(context)) {
      return baseFontSize * 0.9;
    } else if (isTablet(context)) {
      return baseFontSize;
    } else {
      return baseFontSize * 1.1;
    }
  }
  
  static int getCrossAxisCount(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }
  
  static double getCardWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isMobile(context)) {
      return screenWidth - (AppConstants.spacingL * 2);
    } else if (isTablet(context)) {
      return (screenWidth - (AppConstants.spacingXL * 3)) / 2;
    } else {
      return (screenWidth - (AppConstants.spacingXXL * 4)) / 3;
    }
  }
  
  static double getTimelineHeight(BuildContext context) {
    if (isMobile(context)) {
      return AppConstants.timelineHeight * 0.8;
    } else {
      return AppConstants.timelineHeight;
    }
  }
  
  static bool shouldShowSidebar(BuildContext context) {
    return !isMobile(context);
  }
  
  static double getBottomSheetHeight(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    if (isMobile(context)) {
      return screenHeight * 0.6;
    } else {
      return screenHeight * 0.5;
    }
  }
  
  static EdgeInsets getModalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(AppConstants.spacingL);
    } else {
      return EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * 0.1,
        vertical: AppConstants.spacingXXL,
      );
    }
  }
  
  static double getIconSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize * 0.9;
    } else {
      return baseSize;
    }
  }
  
  static TextStyle getResponsiveTextStyle(
    BuildContext context,
    TextStyle baseStyle,
  ) {
    final scaleFactor = isMobile(context) ? 0.9 : 1.0;
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * scaleFactor,
    );
  }
  
  static Widget responsiveBuilder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return desktop ?? tablet ?? mobile;
    }
  }
  
  static double getHorizontalPadding(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isMobile(context)) {
      return AppConstants.spacingL;
    } else if (isTablet(context)) {
      return screenWidth * 0.05;
    } else {
      return screenWidth * 0.1;
    }
  }
  
  static double getVerticalSpacing(BuildContext context) {
    if (isMobile(context)) {
      return AppConstants.spacingL;
    } else {
      return AppConstants.spacingXL;
    }
  }
}