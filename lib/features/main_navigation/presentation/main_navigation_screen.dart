import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../home/presentation/home_screen.dart';
import '../../study/presentation/study_screen.dart';

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
/// | 2     | [_PlaceholderScreen] (Schedule) |
/// | 3     | [_PlaceholderScreen] (Profile)  |
///
/// Using [IndexedStack] keeps all tab widgets alive in memory so their
/// scroll positions and provider state are preserved when switching tabs.
class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    StudyScreen(),
    _PlaceholderScreen(
      label: 'Schedule',
      icon: Icons.calendar_month_rounded,
      subtitle: 'Your study schedule will appear here.',
    ),
    _PlaceholderScreen(
      label: 'Profile',
      icon: Icons.person_rounded,
      subtitle: 'Manage your account and preferences.',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(_navIndexProvider);

    return Scaffold(
      // Remove the default white scaffold background so each child screen
      // can set its own background colour.
      backgroundColor: AppColors.backgroundCream,

      // The [IndexedStack] keeps all children alive — no rebuild cost on tab switch.
      body: IndexedStack(index: currentIndex, children: _screens),

      // Floating pill bottom navigation bar.
      // extendBody = true so the screen content can bleed behind the transparent
      // bottom area and the nav bar floats above it visually.
      extendBody: true,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) => ref.read(_navIndexProvider.notifier).state = i,
      ),
    );
  }
}

// ── Placeholder Screen ─────────────────────────────────────────────────────────

/// A simple "coming soon" placeholder used for tabs not yet implemented.
class _PlaceholderScreen extends StatelessWidget {
  final String label;
  final IconData icon;
  final String subtitle;

  const _PlaceholderScreen({
    required this.label,
    required this.icon,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tinted icon circle
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: AppColors.primaryOrange),
                ),

                const SizedBox(height: 20),

                // Screen label
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // "Coming Soon" chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrangeLighter,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryOrangeLight,
                      width: 1.5,
                    ),
                  ),
                  child: const Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
