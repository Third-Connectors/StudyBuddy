import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_progress_bar.dart';
import '../../domain/models/subject_model.dart';
import '../../data/study_providers.dart';
import '../subject_details_screen.dart';

/// A single subject progress card in the Study screen's subject list.
class SubjectListItemWidget extends ConsumerWidget {
  final SubjectModel subject;

  const SubjectListItemWidget({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedMap = ref.watch(completedChaptersProvider);
    final completedSet = completedMap[subject.name] ?? {};
    
    const totalChapters = 5;
    final dynamicProgress = completedSet.length / totalChapters;
    final dynamicProgressPercent = (dynamicProgress * 100).round();
    final dynamicChapterLabel = '${completedSet.length}/$totalChapters bab';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubjectDetailsScreen(
              subjectName: subject.name,
              icon: subject.icon,
              iconColor: subject.iconColor,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.045),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Subject Icon ─────────────────────────────────────────────────
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: subject.iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(subject.icon, size: 22, color: subject.iconColor),
            ),
  
            const SizedBox(width: 12),
  
            // ── Info Column ──────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Name row + chapter count ─────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Subject name
                      Flexible(
                        child: Text(
                          subject.name,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
  
                      const SizedBox(width: 6),
  
                      // Chapter count  e.g. "4/8 bab"
                      Text(
                        dynamicChapterLabel,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
  
                  const SizedBox(height: 7),
  
                  // ── Progress bar row ─────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: CustomProgressBar(
                          progress: dynamicProgress,
                          height: 5,
                          activeColor: subject.iconColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Percentage label
                      SizedBox(
                        width: 34,
                        child: Text(
                          '$dynamicProgressPercent%',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
  
                  const SizedBox(height: 5),
  
                  // ── Next topic hint ──────────────────────────────────────
                  Text(
                    'Selanjutnya: ${subject.nextTopic}',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
  
            const SizedBox(width: 6),
  
            // ── Trailing Chevron ─────────────────────────────────────────────
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}
