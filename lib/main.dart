import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/main_navigation/presentation/main_navigation_screen.dart';
import 'features/onboarding/presentation/onboarding_screen_1.dart';
import 'features/onboarding/presentation/onboarding_screen_2.dart';
import 'features/onboarding/presentation/onboarding_ptn_screen.dart';

/// Entry point for Study Buddy.
///
/// Bootstrap order:
/// 1. [WidgetsFlutterBinding.ensureInitialized] — safe async setup
/// 2. Lock orientation to portrait (mobile-first design)
/// 3. Configure the system status bar to be transparent with dark icons
/// 4. Wrap everything in [ProviderScope] so Riverpod providers are available
///    throughout the entire widget tree
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Portrait-only orientation ────────────────────────────────────────────
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── Transparent status bar with dark (readable) icons ───────────────────
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

  runApp(
    // ProviderScope is the root Riverpod container — all providers live here.
    const ProviderScope(child: StudyBuddyApp()),
  );
}

/// Root [MaterialApp] widget for Study Buddy.
///
/// Responsibilities:
/// - Applies [AppTheme.lightTheme] globally
/// - Defines named routes for the onboarding flow and main app shell
/// - Sets [OnboardingScreen1] as the initial route
class StudyBuddyApp extends StatelessWidget {
  const StudyBuddyApp({super.key});

  // ── Named Route Table ──────────────────────────────────────────────────────
  static final Map<String, WidgetBuilder> _routes = {
    '/onboarding1': (_) => const OnboardingScreen1(),
    '/onboarding2': (_) => const OnboardingScreen2(),
    '/onboarding_ptn': (_) => const OnboardingPtnScreen(),
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
      initialRoute: '/onboarding1',
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
