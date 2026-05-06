import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'core/services/local_storage_service.dart';

import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/main_navigation/presentation/main_navigation_screen.dart';
import 'features/onboarding/presentation/onboarding_screen_1.dart';
import 'features/onboarding/presentation/onboarding_screen_2.dart';
import 'features/onboarding/presentation/onboarding_ptn_screen.dart';
import 'features/onboarding/presentation/onboarding_vak_screen.dart';
import 'features/onboarding/presentation/onboarding_complete_screen.dart';

/// Entry point untuk Study Buddy.
///
/// Bootstrap order:
/// 1. [WidgetsFlutterBinding.ensureInitialized] — safe async setup
/// 2. Initialize Firebase (for push notifications)
/// 3. Initialize Supabase (for backend, auth, database)
/// 4. Initialize Notification Service
/// 5. Lock orientation to portrait
/// 6. Configure system UI
/// 7. Wrap in [ProviderScope] for Riverpod
void main() async {
  // 1. Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 🔥 Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2.5. 💾 Initialize Local Storage
  await LocalStorageService.init();

  // 3. ⚡ Initialize Supabase
  await Supabase.initialize(
    url: 'https://jxyfjgfupqeutedtsjge.supabase.co',
    anonKey: 'sb_publishable_uQzHGK8HPIYLm55BUtp7xQ_pSqzq-pJ',
  );

  // 4. 📬 Initialize Notification Service
  await NotificationService.instance.initialize();
  await NotificationService.instance.requestPermission();

  // 5. ── Portrait-only orientation ──────────────────────────────────────
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 6. ── Transparent status bar with dark (readable) icons ───────────────
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light, // iOS
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Enable edge-to-edge rendering on Android (draws behind nav bar)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 7. 🚀 Determine Initial Route
  String initialRoute = '/onboarding1';

  final session = Supabase.instance.client.auth.currentSession;
  if (session != null) {
    // User is logged in
    initialRoute = '/home';

    // 💡 Schedule daily study reminder at 7 PM
    NotificationService.instance.scheduleDailyStudyReminder(hour: 19, minute: 0);
  } else {
    // Check if onboarding is already seen
    final onboardingComplete = localStorageProvider.getBool('onboarding_complete');
    if (onboardingComplete) {
      initialRoute = '/login';
    }
  }

  // 8. Run app
  runApp(ProviderScope(child: StudyBuddyApp(initialRoute: initialRoute)));
}

/// Root [MaterialApp] widget for Study Buddy.
class StudyBuddyApp extends StatelessWidget {
  final String initialRoute;

  const StudyBuddyApp({super.key, required this.initialRoute});

  // ── Named Route Table ──────────────────────────────────────────────────────
  static final Map<String, WidgetBuilder> _routes = {
    '/onboarding1': (_) => const OnboardingScreen1(),
    '/onboarding2': (_) => const OnboardingScreen2(),
    '/onboarding_ptn': (_) => const OnboardingPtnScreen(),
    '/vak_test': (_) => const OnboardingVakScreen(),
    '/onboarding_complete': (_) => const OnboardingCompleteScreen(),
    '/login': (_) => const LoginScreen(),
    '/home': (_) => const MainNavigationScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ── App identity ────────────────────────────────────────────────────
      title: 'Study Buddy',
      debugShowCheckedModeBanner: false,

      // ── Theme ───────────────────────────────────────────────────────────
      theme: AppTheme.lightTheme,

      // ── Routing ─────────────────────────────────────────────────────────
      initialRoute: initialRoute,
      routes: _routes,

      // ── Scroll behaviour — subtle over-scroll glow on Android ──────────
      scrollBehavior: const _StudyBuddyScrollBehaviour(),

      // ── Builder — wraps every screen to enforce edge-to-edge safe area ─
      builder: (context, child) {
        // Prevent font scaling beyond 1.15× to protect layout integrity.
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.15),
          ),
          child: child!,
        );
      },
    );
  }
}

// ── Custom Scroll Behaviour ────────────────────────────────────────────────────

/// Removes the default Android over-scroll glow effect so the UI looks
/// identical on iOS and Android — matching the premium feel of the design.
class _StudyBuddyScrollBehaviour extends ScrollBehavior {
  const _StudyBuddyScrollBehaviour();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Return the child unmodified — no glow, no stretch.
    return child;
  }
}
