import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_progress_bar.dart';
import '../data/study_providers.dart';
import 'widgets/ai_suggestion_card_widget.dart';
import 'widgets/subject_list_item_widget.dart';

/// The Study screen — gives the student a comprehensive view of their
/// academic progress across all subjects.
///
/// Layout (top → bottom):
/// 1. Screen header: "Study" title + "Class 12 · 8 Subject" subtitle
/// 2. Overall progress card (white card, orange progress bar, 63 %)
/// 3. Segmented tab control: "Mata Pelajaran" | "SNBT"
/// 4. AI Suggestion card ("Saran AI: Fokus hari ini")
/// 5. Scrollable subject list ([SubjectListItemWidget] × n)
class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallData = ref.watch(studyOverallProvider);
    final subjects = ref.watch(subjectListProvider);
    final selectedTab = ref.watch(studyTabIndexProvider);

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── 1. Screen Header ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Study', style: AppTextStyles.headlineLarge),
                        const SizedBox(height: 2),
                        Text(
                          'Class 12 - ${overallData.totalSubjects} Subject',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 2. Overall Progress Card ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _OverallProgressCard(data: overallData),
            ),
          ),

          // ── 3. Segmented Tab Control ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: _SegmentedTabBar(
                selectedIndex: selectedTab,
                onChanged: (i) =>
                    ref.read(studyTabIndexProvider.notifier).state = i,
              ),
            ),
          ),

          // ── 4. AI Suggestion Card ─────────────────────────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: AiSuggestionCardWidget(),
            ),
          ),

          // ── 5. Subject List ───────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            sliver: SliverList.separated(
              itemCount: subjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return SubjectListItemWidget(subject: subjects[index]);
              },
            ),
          ),

          // ── Bottom padding (keeps content above the floating nav bar) ─
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

// ── Overall Progress Card ──────────────────────────────────────────────────────

class _OverallProgressCard extends StatelessWidget {
  final StudyOverallData data;

  const _OverallProgressCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final percentLabel = '${(data.overallProgress * 100).round()}%';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progres Keseluruhan', style: AppTextStyles.titleSmall),
              Text(
                percentLabel,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar
          CustomProgressBar(progress: data.overallProgress, height: 8),

          const SizedBox(height: 8),

          // Supporting note
          Text(
            '${data.subjectsAbove80} dari ${data.totalSubjects} '
            'mata pelajaran sudah di atas 80%',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

// ── Segmented Tab Bar ──────────────────────────────────────────────────────────

/// A two-segment pill-style toggle control for switching between
/// "Mata Pelajaran" and "SNBT" views.
class _SegmentedTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _SegmentedTabBar({
    required this.selectedIndex,
    required this.onChanged,
  });

  // Internal tab data model
  static const List<_TabData> _tabs = [
    _TabData(icon: Icons.menu_book_rounded, label: 'Mata Pelajaran'),
    _TabData(icon: Icons.track_changes_rounded, label: 'SNBT'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(30), // Lebih melengkung (curvy)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isSelected = selectedIndex == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryOrange
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _tabs[i].icon,
                      size: 15,
                      color: isSelected
                          ? AppColors.textWhite
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _tabs[i].label,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.textWhite
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Tab Data ───────────────────────────────────────────────────────────────────

class _TabData {
  final IconData icon;
  final String label;

  const _TabData({required this.icon, required this.label});
}
