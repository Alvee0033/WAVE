import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  // Route paths
  static const String splashRoute = '/splash';
  static const String dashboardRoute = '/dashboard';
  static const String regionDetailsRoute = '/region';
  
  // Navigation methods
  static void goToSplash(BuildContext context) {
    context.go(splashRoute);
  }
  
  static void goToDashboard(BuildContext context) {
    context.go(dashboardRoute);
  }
  
  static void goToRegionDetails(BuildContext context, String regionId) {
    context.go('$regionDetailsRoute/$regionId');
  }
  
  static void pushToRegionDetails(BuildContext context, String regionId) {
    context.push('$regionDetailsRoute/$regionId');
  }
  
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      goToDashboard(context);
    }
  }
  
  static void goBackToDashboard(BuildContext context) {
    context.go(dashboardRoute);
  }
  
  // Helper methods
  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }
  
  static String getCurrentRoute(BuildContext context) {
    return GoRouterState.of(context).uri.toString();
  }
  
  static Map<String, String> getRouteParameters(BuildContext context) {
    return GoRouterState.of(context).pathParameters;
  }
  
  static Map<String, String> getQueryParameters(BuildContext context) {
    return GoRouterState.of(context).uri.queryParameters;
  }
  
  // Route validation
  static bool isCurrentRoute(BuildContext context, String route) {
    return getCurrentRoute(context) == route;
  }
  
  static bool isDashboardRoute(BuildContext context) {
    return isCurrentRoute(context, dashboardRoute);
  }
  
  static bool isSplashRoute(BuildContext context) {
    return isCurrentRoute(context, splashRoute);
  }
  
  static bool isRegionDetailsRoute(BuildContext context) {
    return getCurrentRoute(context).startsWith(regionDetailsRoute);
  }
  
  // Navigation with animation
  static void navigateWithFadeTransition(
    BuildContext context,
    Widget destination,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
  
  static void navigateWithSlideTransition(
    BuildContext context,
    Widget destination, {
    SlideDirection direction = SlideDirection.fromRight,
  }) {
    Offset beginOffset;
    switch (direction) {
      case SlideDirection.fromLeft:
        beginOffset = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.fromRight:
        beginOffset = const Offset(1.0, 0.0);
        break;
      case SlideDirection.fromTop:
        beginOffset = const Offset(0.0, -1.0);
        break;
      case SlideDirection.fromBottom:
        beginOffset = const Offset(0.0, 1.0);
        break;
    }
    
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
  
  // Error handling
  static void handleNavigationError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation error: $error'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  // Deep link handling
  static void handleDeepLink(BuildContext context, String link) {
    try {
      final uri = Uri.parse(link);
      final path = uri.path;
      
      if (path.startsWith('/region/')) {
        final regionId = path.split('/').last;
        goToRegionDetails(context, regionId);
      } else if (path == '/dashboard') {
        goToDashboard(context);
      } else {
        goToDashboard(context);
      }
    } catch (e) {
      handleNavigationError(context, 'Invalid deep link: $link');
      goToDashboard(context);
    }
  }
}

enum SlideDirection {
  fromLeft,
  fromRight,
  fromTop,
  fromBottom,
}