import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Floating, rounded-pill bottom navigation bar used across all main app screens.
///
/// Design spec:
/// - Dark navy pill background ([AppColors.bottomNavBg])
/// - Four icons: Home, Study (Book), Schedule (Calendar), Profile (Person)
/// - Active icon is [AppColors.primaryOrange] with a subtle highlighted pill behind it
/// - Smooth [AnimatedContainer] transition on tap
class CustomBottomNavBar extends StatelessWidget {
  /// The index of the currently selected tab (0–3).
  final int currentIndex;

  /// Callback fired when the user taps a nav item.
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItemData> _items = [
    _NavItemData(icon: Icons.home_rounded, label: 'Home'),
    _NavItemData(icon: Icons.menu_book_rounded, label: 'Study'),
    _NavItemData(icon: Icons.calendar_month_rounded, label: 'Schedule'),
    _NavItemData(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    // Use SafeArea so the bar sits above the system home indicator on iOS/Android.
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.bottomNavBg,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _items.length,
              (i) => _NavBarItem(
                data: _items[i],
                isActive: currentIndex == i,
                onTap: () => onTap(i),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Internal data model ────────────────────────────────────────────────────────

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData({required this.icon, required this.label});
}

// ── Single nav item widget ─────────────────────────────────────────────────────

class _NavBarItem extends StatelessWidget {
  final _NavItemData data;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          // Subtle orange pill behind the active icon
          color: isActive
              ? AppColors.primaryOrange.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          data.icon,
          size: 24,
          color: isActive
              ? AppColors.primaryOrange
              : AppColors.bottomNavInactiveIcon,
        ),
      ),
    );
  }
}
