import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:studybuddy/core/theme/app_colors.dart';
import 'package:studybuddy/features/home/data/home_providers.dart';
import 'package:studybuddy/features/auth/data/models/user_model.dart';

/// Displays the three gamification statistics row on the Home screen:
/// ⚡ XP Points  |  📊 Ranking  |  ⭐ Presence
///
/// Each stat lives in its own soft-shadow white card with a tinted
/// circular icon, a bold value, and a muted label — matching the
/// design mockup exactly.
class StatsRowWidget extends ConsumerWidget {
  const StatsRowWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value ?? UserModel(
      id: '',
      email: '',
      name: 'Student',
      gradeLevel: '12',
      xpPoints: 0,
      rank: 1,
      presencePercentage: 0,
      targetUniversity: 'Universitas Indonesia',
      fireStreak: 0,
      createdAt: DateTime.now(),
    );

    return Row(
      children: [
        // ── XP Points ──────────────────────────────────────────────────
        Expanded(
          child: _StatCard(
            icon: Icons.bolt_rounded,
            iconColor: AppColors.statXpIcon,
            iconBgColor: AppColors.statXpBg,
            value: _formatXp(user.xpPoints),
            label: 'XP Point',
          ),
        ),

        const SizedBox(width: 10),

        // ── Ranking ────────────────────────────────────────────────────
        Expanded(
          child: _StatCard(
            icon: Icons.leaderboard_rounded,
            iconColor: AppColors.statRankIcon,
            iconBgColor: AppColors.statRankBg,
            value: 'Rank ${user.rank}',
            label: 'Ranking',
          ),
        ),

        const SizedBox(width: 10),

        // ── Presence ───────────────────────────────────────────────────
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            iconColor: AppColors.statPresenceIcon,
            iconBgColor: AppColors.statPresenceBg,
            value: '${user.presencePercentage}%',
            label: 'Presence',
          ),
        ),
      ],
    );
  }

  /// Formats a raw XP integer as a thousands-separated string.
  /// e.g. 1250 → "1,250" | 980 → "980"
  static String _formatXp(int xp) {
    if (xp >= 1000) {
      final thousands = xp ~/ 1000;
      final remainder = (xp % 1000).toString().padLeft(3, '0');
      return '$thousands,$remainder';
    }
    return xp.toString();
  }
}

// ── Individual Stat Card ───────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Tinted Icon Circle ─────────────────────────────────────────
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),

          const SizedBox(height: 9),

          // ── Stat Value ─────────────────────────────────────────────────
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 3),

          // ── Label ──────────────────────────────────────────────────────
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
