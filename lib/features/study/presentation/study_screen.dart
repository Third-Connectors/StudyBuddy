import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_progress_bar.dart';
import '../data/study_providers.dart';
import '../domain/models/subject_model.dart';
import '../domain/providers/schedule_provider.dart';
import '../../home/data/home_providers.dart';
import 'widgets/ai_suggestion_card_widget.dart';
import 'widgets/subject_list_item_widget.dart';
import '../../subscription/data/subscription_provider.dart';
import '../../subscription/presentation/subscription_screen.dart';

/// The Study screen — gives the student a comprehensive view of their
/// academic progress across all subjects.
///
/// Layout (top → bottom):
/// 1. Screen header: "Study" title + "Class 12 · 8 Subject" subtitle
/// 2. Overall progress card (white card, orange progress bar, 63 %)
/// 3. Segmented tab control: "Mata Pelajaran" | "SNBT"
/// 4. AI Suggestion card ("Saran AI: Fokus hari ini")
class StudyScreen extends ConsumerWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallData = ref.watch(studyOverallProvider);
    final subjects = ref.watch(subjectListProvider);
    final selectedTab = ref.watch(studyTabIndexProvider);
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final hasSchedule = scheduleState.schedules.isNotEmpty;
    final countdown = ref.watch(countdownProvider);
    final subState = ref.watch(subscriptionProvider);
    final isSnbtLocked = countdown.days >= 180 && !subState.isPremium;    // Filter mata pelajaran berdasarkan jadwal jika diisi
    final List<SubjectModel> displaySubjects;
    if (!hasSchedule) {
      displaySubjects = [];
    } else if (selectedTab == 0) {
      // Dapatkan semua mata pelajaran unik dari jadwal secara konsisten!
      // Abaikan kegiatan non-akademis (seperti istirahat, ishoma, dll.) dari list study
      final nonAcademicKeywords = {
        'ishoma', 'istirahat', 'isoma', 'sholat', 'makan', 'tidur', 
        'free', 'kosong', 'break', 'refreshing', 'bermain', 'game', 'main'
      };

      final uniqueScheduledSubjects = scheduleState.schedules
          .map((s) => s.subject.trim())
          .where((sub) => sub.isNotEmpty && !nonAcademicKeywords.any((keyword) => sub.toLowerCase().contains(keyword)))
          .toSet();

      displaySubjects = uniqueScheduledSubjects.map((subName) {
        final upperSub = subName.toUpperCase();
        var iconColor = const Color(0xFF3B82F6);
        var icon = Icons.menu_book_rounded;
        var nextTopic = 'Latihan Soal & Review';
        var progress = 0.35;
        var currentChapter = 3;
        var totalChapters = 8;
        
        if (upperSub.contains('SB') || upperSub.contains('SENI')) {
          iconColor = const Color(0xFFEC4899);
          icon = Icons.palette_rounded;
          nextTopic = 'Apresiasi Karya Seni';
          progress = 0.60;
          currentChapter = 5;
        } else if (upperSub.contains('ING') || upperSub.contains('ENG') || upperSub.contains('EL')) {
          iconColor = const Color(0xFF3B82F6);
          icon = Icons.translate_rounded;
          nextTopic = 'Reading & Writing Exercise';
          progress = 0.45;
          currentChapter = 4;
        } else if (upperSub.contains('AL') || upperSub.contains('MTK') || upperSub.contains('MW') || upperSub.contains('MAT')) {
          iconColor = const Color(0xFFF59E0B);
          icon = Icons.functions_rounded;
          nextTopic = 'Latihan Rumus & Aljabar';
          progress = 0.50;
          currentChapter = 6;
        } else if (upperSub.contains('GEO')) {
          iconColor = const Color(0xFF10B981);
          icon = Icons.public_rounded;
          nextTopic = 'Peta & Pola Spasial';
          progress = 0.40;
          currentChapter = 3;
        } else if (upperSub.contains('SOS')) {
          iconColor = const Color(0xFF8B5CF6);
          icon = Icons.people_rounded;
          nextTopic = 'Interaksi Sosial';
          progress = 0.55;
          currentChapter = 4;
        } else if (upperSub.contains('PAI') || upperSub.contains('AGAMA')) {
          iconColor = const Color(0xFF14B8A6);
          icon = Icons.mosque_rounded;
          nextTopic = 'Akhlak & Sejarah Kebudayaan';
          progress = 0.70;
          currentChapter = 5;
        } else if (upperSub.contains('BK')) {
          iconColor = const Color(0xFF6366F1);
          icon = Icons.psychology_rounded;
          nextTopic = 'Konseling Karir';
          progress = 0.80;
          currentChapter = 6;
        } else if (upperSub.contains('PKWU') || upperSub.contains('PKW')) {
          iconColor = const Color(0xFFF59E0B);
          icon = Icons.business_center_rounded;
          nextTopic = 'Perencanaan Usaha';
          progress = 0.30;
          currentChapter = 2;
        } else if (upperSub.contains('BIN') || upperSub.contains('IND')) {
          iconColor = const Color(0xFFEF4444);
          icon = Icons.history_edu_rounded;
          nextTopic = 'Menulis Karya Ilmiah';
          progress = 0.65;
          currentChapter = 5;
        } else if (upperSub.contains('SEJ')) {
          iconColor = const Color(0xFF6366F1);
          icon = Icons.history_rounded;
          nextTopic = 'Peristiwa Sejarah Dunia';
          progress = 0.40;
          currentChapter = 3;
        } else if (upperSub.contains('PPKN') || upperSub.contains('PPK')) {
          iconColor = const Color(0xFF10B981);
          icon = Icons.gavel_rounded;
          nextTopic = 'Sistem Hukum & Konstitusi';
          progress = 0.50;
          currentChapter = 4;
        } else if (upperSub.contains('PJOK') || upperSub.contains('OR')) {
          iconColor = const Color(0xFFF59E0B);
          icon = Icons.sports_soccer_rounded;
          nextTopic = 'Kesehatan Jasmani';
          progress = 0.75;
          currentChapter = 6;
        }

        return SubjectModel(
          name: subName,
          iconColor: iconColor,
          icon: icon,
          currentChapter: currentChapter,
          totalChapters: totalChapters,
          progress: progress,
          nextTopic: nextTopic,
        );
      }).toList();
    } else if (isSnbtLocked) {
      displaySubjects = [];
    } else {
      // Tab SNBT - Berikan modul SNBT dinamis yang berkualitas
      displaySubjects = [
        SubjectModel(
          name: 'Penalaran Matematika',
          iconColor: const Color(0xFFF59E0B),
          icon: Icons.functions_rounded,
          currentChapter: 3,
          totalChapters: 6,
          progress: 0.45,
          nextTopic: 'Aritmetika & Aljabar',
        ),
        SubjectModel(
          name: 'Literasi B. Indonesia',
          iconColor: const Color(0xFF14B8A6),
          icon: Icons.menu_book_rounded,
          currentChapter: 4,
          totalChapters: 6,
          progress: 0.65,
          nextTopic: 'Makna Paragraf Kontekstual',
        ),
        SubjectModel(
          name: 'Literasi B. Inggris',
          iconColor: const Color(0xFF3B82F6),
          icon: Icons.translate_rounded,
          currentChapter: 2,
          totalChapters: 5,
          progress: 0.35,
          nextTopic: 'Reading Comprehension',
        ),
        SubjectModel(
          name: 'Penalaran Umum',
          iconColor: const Color(0xFF8B5CF6),
          icon: Icons.psychology_rounded,
          currentChapter: 3,
          totalChapters: 6,
          progress: 0.50,
          nextTopic: 'Logika Analitis & Kognitif',
        ),
      ];
    }

    final completedMap = ref.watch(completedChaptersProvider);
    double calculatedOverallProgress = 0.0;
    int subjectsAbove80Count = 0;
    
    if (displaySubjects.isNotEmpty) {
      double totalProgressSum = 0.0;
      for (final s in displaySubjects) {
        final completedSet = completedMap[s.name] ?? {};
        final subProgress = completedSet.length / 5.0; // 5 bab total
        totalProgressSum += subProgress;
        if (subProgress >= 0.8) {
          subjectsAbove80Count++;
        }
      }
      calculatedOverallProgress = totalProgressSum / displaySubjects.length;
    }

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── 1. Screen Header ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Study', style: AppTextStyles.headlineLarge),
                        const SizedBox(height: 2),
                        Text(
                          hasSchedule 
                              ? 'Class 12 - ${displaySubjects.length} Active Subjects'
                              : 'Class 12 - No Active Schedule',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildPremiumBadgeOrButton(context, ref),
                ],
              ),
            ),
          ),

          if (!hasSchedule) ...[
            // Tampilkan Banner ajakan mengisi jadwal jika masih kosong
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFEF3C7), Color(0xFFFFFBEB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFEF3C7).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 52, color: AppColors.primaryOrange),
                      const SizedBox(height: 16),
                      Text(
                        'Yuk, Atur Jadwal Belajarmu!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Buat atau pindai jadwal belajarmu terlebih dahulu di menu Jadwal untuk melihat progress belajar, bab materi, dan modul SNBT yang relevan untukmu!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            // ── 2. Overall Progress Card ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _OverallProgressCard(
                  data: StudyOverallData(
                    overallProgress: displaySubjects.isEmpty ? 0.0 : calculatedOverallProgress,
                    subjectsAbove80: displaySubjects.isEmpty ? 0 : subjectsAbove80Count,
                    totalSubjects: displaySubjects.length,
                  ),
                ),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: AiSuggestionCardWidget(activeSubjects: displaySubjects),
              ),
            ),

            // ── 5. Subject List ───────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: displaySubjects.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              (selectedTab == 1 && isSnbtLocked) 
                                  ? Icons.lock_clock_rounded 
                                  : Icons.menu_book_rounded,
                              size: 48,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              (selectedTab == 1 && isSnbtLocked)
                                  ? 'Masih belum waktunyaa!'
                                  : 'Belum ada mata pelajaran yang terjadwal untuk hari ini.',
                              style: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              (selectedTab == 1 && isSnbtLocked)
                                  ? 'Persiapan modul SNBT otomatis terbuka ketika hitung mundur UTBK kurang dari 1 semester (180 hari) lagi.'
                                  : 'Coba pilih hari lain atau perbarui jadwal belajarmu.',
                              style: AppTextStyles.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList.separated(
                      itemCount: displaySubjects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return SubjectListItemWidget(subject: displaySubjects[index]);
                      },
                    ),
            ),
          ],

          // ── Bottom padding (keeps content above the floating nav bar) ─
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildPremiumBadgeOrButton(BuildContext context, WidgetRef ref) {
    final subState = ref.watch(subscriptionProvider);

    if (subState.tier == SubscriptionTier.premium) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.amber, Color(0xFFD97706)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              'PREMIUM',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    } else if (subState.tier == SubscriptionTier.reguler) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A8A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF60A5FA), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              'REGULER',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              'Get PRO',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.amber,
              ),
            ),
          ],
        ),
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
    final isEmpty = data.totalSubjects == 0;
    final percentLabel = isEmpty ? '0%' : '${(data.overallProgress * 100).round()}%';
    final progressColor = isEmpty ? AppColors.textLight : AppColors.primaryOrange;

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
                  color: progressColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar
          CustomProgressBar(
            progress: isEmpty ? 0.0 : data.overallProgress, 
            height: 8,
            activeColor: progressColor,
          ),

          const SizedBox(height: 8),

          // Supporting note
          Text(
            isEmpty 
                ? 'Belum ada progres karena jadwal masih kosong.'
                : '${data.subjectsAbove80} dari ${data.totalSubjects} mata pelajaran sudah di atas 80%',
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
