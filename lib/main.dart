import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'screens/splash_screen.dart';
import 'screens/main_dashboard.dart';
import 'screens/region_details.dart';
import 'screens/login_screen.dart';
import 'providers/app_state.dart';
import 'theme/app_theme.dart';
import 'services/navigation_service.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize WebView platform for web
  if (WebViewPlatform.instance == null) {
    WebViewPlatform.instance = WebWebViewPlatform();
  }
  
  // Initialize Firebase with platform-specific options
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const WaveApp());
}

class WaveApp extends StatelessWidget {
  const WaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp.router(
        title: 'WAVE - World Analysis & Visualization Engine',
        theme: AppTheme.darkTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: NavigationService.dashboardRoute, // Go directly to dashboard
  errorBuilder: (context, state) => _ErrorPage(error: state.error.toString()),
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: NavigationService.splashRoute,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: NavigationService.dashboardRoute,
      name: 'dashboard',
      builder: (context, state) => const MainDashboard(),
    ),
    GoRoute(
      path: '${NavigationService.regionDetailsRoute}/:regionId',
      name: 'regionDetails',
      builder: (context, state) {
        final regionId = state.pathParameters['regionId'];
        if (regionId == null || regionId.isEmpty) {
          return const _ErrorPage(error: 'Invalid region ID');
        }
        return RegionDetails(regionId: regionId);
      },
    ),
  ],
  // redirect: (context, state) {
  //   final user = FirebaseAuth.instance.currentUser;
  //   final isLoginRoute = state.matchedLocation == '/login';
    
  //   // If user is not logged in and not on login page, redirect to login
  //   if (user == null && !isLoginRoute) {
  //     return '/login';
  //   }
    
  //   // If user is logged in and on login page, redirect to dashboard
  //   if (user != null && isLoginRoute) {
  //     return NavigationService.dashboardRoute;
  //   }
    
  //   return null;
  // },
);

class _ErrorPage extends StatelessWidget {
  final String error;
  
  const _ErrorPage({required this.error});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.ceresColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => NavigationService.goToDashboard(context),
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}