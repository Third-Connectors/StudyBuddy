import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../home/presentation/home_screen.dart';
import '../../study/presentation/study_screen.dart';
import '../../leaderboard/presentation/leaderboard_screen.dart';
import '../../study/presentation/schedule_scanner_screen.dart';
import '../../profile/presentation/profile_screen.dart';

// ── Active tab index provider ──────────────────────────────────────────────────

/// Tracks which bottom-nav tab is currently selected (0–3).
/// Scoped to this file — consumed only by [MainNavigationScreen].
final _navIndexProvider = StateProvider<int>((ref) => 0);

// ── Main Navigation Shell ──────────────────────────────────────────────────────

/// The root application shell that hosts the four main tabs via an
/// [IndexedStack] and renders the floating [CustomBottomNavBar].
///
/// Tab map:
/// | Index | Screen                     |
/// |-------|----------------------------|
/// | 0     | [HomeScreen]               |
/// | 1     | [StudyScreen]              |
/// | 2     | [ScheduleScannerScreen]    |
/// | 3     | [ProfileScreen]            |
///
/// Using [IndexedStack] keeps all tab widgets alive in memory so their
/// scroll positions and provider state are preserved when switching tabs.
class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    StudyScreen(),
    LeaderboardScreen(), // Index 2
    ScheduleScannerScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(_navIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: Stack(
        children: [
          // ── Konten Halaman ─────────────────────────────────────────
          IndexedStack(index: currentIndex, children: _screens),

          // ── Floating Navigation Bar ────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavBar(
              currentIndex: currentIndex,
              onTap: (i) => ref.read(_navIndexProvider.notifier).state = i,
            ),
          ),
        ],
      ),
    );
  }
}
