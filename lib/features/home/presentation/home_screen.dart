import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/home_providers.dart';
import 'widgets/countdown_card_widget.dart';
import 'widgets/quiz_list_item_widget.dart';
import 'widgets/stats_row_widget.dart';

/// The main Home dashboard screen.
///
/// Sections (top → bottom, inside a [CustomScrollView]):
/// 1. Personalised greeting header — name, class badge, fire-streak badge
/// 2. [CountdownCardWidget] — UTBK SNBT 2026 countdown card
/// 3. [StatsRowWidget] — XP / Rank / Presence gamification stats
/// 4. "Latest Quiz" section header
/// 5. [QuizListItemWidget] list — Bahasa Indonesia, Matematika, Bahasa Inggris
///
/// State is supplied entirely through Riverpod providers defined in
/// [home_providers.dart], making this widget trivially unit-testable.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final quizItems = ref.watch(quizItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── 1. Greeting Header ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: _GreetingHeader(
                  name: user.name,
                  gradeClass: user.gradeClass,
                  fireStreak: user.fireStreak,
                ),
              ),
            ),

            // ── 2. UTBK Countdown Card ─────────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: CountdownCardWidget(),
              ),
            ),

            // ── 3. Stats Row ───────────────────────────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: StatsRowWidget(),
              ),
            ),

            // ── 4. "Latest Quiz" Section Header ───────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Latest Quiz', style: AppTextStyles.titleLarge),
                    GestureDetector(
                      onTap: () {
                        // TODO: navigate to full quiz list
                      },
                      child: Text(
                        'See All',
                        style: GoogleFonts.nunito(
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

            // ── 5. Quiz List ───────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.builder(
                itemCount: quizItems.length,
                itemBuilder: (context, index) {
                  return QuizListItemWidget(quiz: quizItems[index]);
                },
              ),
            ),

            // Bottom padding so the last card isn't hidden behind the nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }
}

// ── Greeting Header ────────────────────────────────────────────────────────────

/// The personalised top section of the Home screen.
///
/// Renders:
/// - "Welcome, Good Morning" subtitle
/// - Large bold user name with 👋 wave emoji
/// - Orange "Class 12" chip
/// - Flame + streak count badge (top-right)
class _GreetingHeader extends StatelessWidget {
  final String name;
  final String gradeClass;
  final int fireStreak;

  const _GreetingHeader({
    required this.name,
    required this.gradeClass,
    required this.fireStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left: greeting text block ────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle
              Text(
                'Welcome, Good Morning',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 3),

              // User name
              Text(
                '$name! 👋',
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Grade class badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  gradeClass,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // ── Right: fire streak badge ─────────────────────────────────────
        _FireStreakBadge(count: fireStreak),
      ],
    );
  }
}

// ── Fire Streak Badge ──────────────────────────────────────────────────────────

class _FireStreakBadge extends StatelessWidget {
  final int count;

  const _FireStreakBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 17)),
          const SizedBox(width: 5),
          Text(
            '$count',
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryOrange,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
