import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/quiz_item_model.dart';

/// A single card in the "Latest Quiz" list on [HomeScreen].
///
/// Visual variants:
/// - **Done** — white card with a green badge ("Done").
/// - **In Progress** — warm-orange tinted card with an orange solid badge ("In Progress").
/// - **To do** — white card with plain grey text ("To do").
class QuizListItemWidget extends StatelessWidget {
  final QuizItemModel quiz;

  const QuizListItemWidget({super.key, required this.quiz});

  // ── Derived colours ────────────────────────────────────────────────────────

  Color get _cardBg => quiz.status == QuizStatus.inProgress
      ? AppColors.primaryOrangeLighter
      : AppColors.surfaceWhite;

  Border get _cardBorder => quiz.status == QuizStatus.inProgress
      ? Border.all(color: AppColors.primaryOrangeLight, width: 1.5)
      : Border.all(color: AppColors.divider, width: 1.0);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: _cardBorder,
        boxShadow: quiz.status != QuizStatus.inProgress
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // ── Subject icon ─────────────────────────────────────────────────
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: quiz.subjectColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.book_rounded, size: 18, color: quiz.subjectColor),
          ),

          const SizedBox(width: 12),

          // ── Subject name ─────────────────────────────────────────────────
          Expanded(
            child: Text(
              quiz.subject,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 8),

          // ── Status badge ─────────────────────────────────────────────────
          _buildStatusBadge(),
        ],
      ),
    );
  }

  // ── Status badge factory ───────────────────────────────────────────────────

  Widget _buildStatusBadge() {
    switch (quiz.status) {
      // ── Done ──────────────────────────────────────────────────────────────
      case QuizStatus.done:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.statusDoneBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Done',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.statusDoneText,
            ),
          ),
        );

      // ── In Progress ───────────────────────────────────────────────────────
      case QuizStatus.inProgress:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'In Progress',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite,
            ),
          ),
        );

      // ── To Do ─────────────────────────────────────────────────────────────
      case QuizStatus.toDo:
        return Text(
          'To do',
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.statusToDoText,
          ),
        );
    }
  }
}
