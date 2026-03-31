import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/vak_question_model.dart';
import '../domain/models/vak_result_model.dart';

// ── Questions ──────────────────────────────────────────────────────────────────

/// All 20 VAK survey questions.
/// Each question has exactly 3 options: visual, auditory, kinesthetic — in order.
final vakQuestionsProvider = Provider<List<VakQuestion>>((ref) {
  return const [
    // ── Q1 ──────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 1,
      question: 'Ketika belajar materi baru, kamu lebih suka...',
      options: [
        VakOption(
          text: 'Membaca buku, catatan, atau melihat diagram',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Mendengarkan penjelasan guru atau podcast',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Langsung mencoba sendiri atau praktik',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q2 ──────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 2,
      question: 'Saat mengingat informasi, kamu biasanya...',
      options: [
        VakOption(
          text: 'Membayangkan dalam bentuk gambar atau tulisan',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Mengulang-ulang dalam kepala seperti mendengar suara',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Menggerakkan tubuh atau menulis ulang',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q3 ──────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 3,
      question: 'Di kelas, kamu paling mudah mengerti ketika...',
      options: [
        VakOption(
          text: 'Guru menulis di papan tulis dengan gambar/diagram',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Guru menjelaskan secara lisan dengan detail',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Ada kegiatan praktikum atau diskusi kelompok',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q4 ──────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 4,
      question: 'Ketika belajar kata baru dalam bahasa asing, kamu...',
      options: [
        VakOption(
          text: 'Menulis berulang-ulang atau melihat flashcard',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Mengucapkannya keras-keras berulang kali',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Menggunakannya langsung dalam kalimat',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q5 ──────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 5,
      question: 'Cara kamu mengingat nomor telepon adalah...',
      options: [
        VakOption(
          text: 'Membayangkan angka-angkanya secara visual',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Mengucapkannya dalam hati berulang-ulang',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Mengetikkannya beberapa kali',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q6 ──────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 6,
      question: 'Ketika mengerjakan soal matematika, kamu lebih suka...',
      options: [
        VakOption(
          text: 'Melihat contoh soal yang mirip dari buku',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Mendengar langkah-langkah penyelesaiannya',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Langsung mencoba mengerjakan sendiri',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q7 ──────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 7,
      question:
          'Saat harus menjelaskan sesuatu kepada teman, kamu cenderung...',
      options: [
        VakOption(
          text: 'Menggambar diagram atau menulis poin-poinnya',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Menjelaskan secara lisan dengan detail',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Menunjukkan contoh langsung atau simulasi',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q8 ──────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 8,
      question: 'Hiburan favoritmu adalah...',
      options: [
        VakOption(
          text: 'Membaca buku, komik, atau menonton film',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Mendengarkan musik atau podcast',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Olahraga, memasak, atau kerajinan tangan',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q9 ──────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 9,
      question: 'Ketika memberi petunjuk arah, kamu lebih suka...',
      options: [
        VakOption(
          text: 'Menggambar peta atau menuliskan langkah-langkahnya',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Memberitahu secara lisan langkah demi langkah',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Mengantar atau menunjukkan langsung',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q10 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 10,
      question:
          'Saat belajar untuk ujian, metode yang paling efektif untukmu...',
      options: [
        VakOption(
          text: 'Membuat mind map atau rangkuman visual',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Membaca keras-keras atau diskusi dengan teman',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Membuat soal latihan dan langsung dikerjakan',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q11 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 11,
      question: 'Ketika presentasi, kamu lebih nyaman...',
      options: [
        VakOption(
          text: 'Mengandalkan slide PowerPoint yang visual',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Berbicara sambil menjelaskan dengan kata-kata',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Melakukan demonstrasi langsung',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q12 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 12,
      question: 'Kamu lebih mudah mengikuti...',
      options: [
        VakOption(
          text: 'Instruksi tertulis dengan gambar langkah demi langkah',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Instruksi lisan yang dijelaskan dengan jelas',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Menonton seseorang melakukannya lalu ikut mencoba',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q13 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 13,
      question: 'Ketika membaca buku pelajaran, kamu...',
      options: [
        VakOption(
          text: 'Memperhatikan diagram, grafik, dan highlight warna',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Membaca dalam hati sambil \'mendengar\' suara',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Membaca sambil membuat catatan dan coret-coretan',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q14 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 14,
      question: 'Jika sedang bosan di kelas, kamu biasanya...',
      options: [
        VakOption(
          text: 'Melamun atau menggambar sesuatu di buku',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Bernyanyi atau mengetuk-ngetuk sesuatu',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Bergerak-gerak atau memainkan sesuatu',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q15 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 15,
      question: 'Dalam kelompok belajar, peranmu biasanya...',
      options: [
        VakOption(
          text: 'Yang membuat ringkasan visual atau papan tulis',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Yang paling banyak bicara dan menjelaskan',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Yang paling aktif mengerjakan soal latihan',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q16 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 16,
      question: 'Ketika membeli gadget baru, kamu...',
      options: [
        VakOption(
          text: 'Membaca manual atau menonton review video',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Menelepon teman yang tahu untuk ditanya-tanya',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Langsung mencoba sendiri semua fiturnya',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q17 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 17,
      question: 'Cara kamu berkonsentrasi yang terbaik adalah...',
      options: [
        VakOption(
          text: 'Di tempat yang rapi dan tidak berantakan',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Di tempat yang tenang, bebas gangguan suara',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Sambil bergerak atau di lingkungan yang nyaman fisik',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q18 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 18,
      question: 'Saat memahami konsep abstrak, kamu butuh...',
      options: [
        VakOption(
          text: 'Visualisasi berupa gambar atau animasi',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Analogi yang dijelaskan secara verbal',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Contoh nyata yang bisa kamu rasakan langsung',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q19 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 19,
      question: 'Kamu paling ingat sesuatu jika...',
      options: [
        VakOption(
          text: 'Kamu menulis atau membacanya berulang kali',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Kamu mendengar atau mengucapkannya berulang kali',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Kamu melakukan atau mengalaminya langsung',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),

    // ── Q20 ─────────────────────────────────────────────────────────────────
    VakQuestion(
      id: 20,
      question: 'Tipe ujian yang menurutmu paling fair adalah...',
      options: [
        VakOption(
          text: 'Ujian tertulis dengan soal-soal visual/diagram',
          style: VakStyle.visual,
          icon: Icons.visibility_rounded,
        ),
        VakOption(
          text: 'Presentasi lisan atau wawancara',
          style: VakStyle.auditory,
          icon: Icons.hearing_rounded,
        ),
        VakOption(
          text: 'Ujian praktik atau proyek nyata',
          style: VakStyle.kinesthetic,
          icon: Icons.touch_app_rounded,
        ),
      ],
    ),
  ];
});

// ── Survey navigation state ────────────────────────────────────────────────────

/// The index of the question currently displayed (0–19).
final vakCurrentIndexProvider = StateProvider<int>((ref) => 0);

// ── Answers state ──────────────────────────────────────────────────────────────

/// Maps questionId → the [VakStyle] the user selected for that question.
final vakAnswersProvider = StateProvider<Map<int, VakStyle>>((ref) => {});

// ── Computed result ────────────────────────────────────────────────────────────

/// Computes a [VakResult] once all questions have been answered.
/// Returns `null` while the survey is still in progress.
final vakResultProvider = Provider<VakResult?>((ref) {
  final answers = ref.watch(vakAnswersProvider);
  final questions = ref.watch(vakQuestionsProvider);

  if (answers.length < questions.length) return null;

  int v = 0, a = 0, k = 0;
  for (final style in answers.values) {
    if (style == VakStyle.visual) {
      v++;
    } else if (style == VakStyle.auditory) {
      a++;
    } else {
      k++;
    }
  }

  return VakResult(visualScore: v, auditoryScore: a, kinestheticScore: k);
});

// ── Persisted result ───────────────────────────────────────────────────────────

/// Holds the [VakResult] that was saved when the user completed the survey.
/// Persists across navigations so [OnboardingCompleteScreen] can read it.
final savedVakResultProvider = StateProvider<VakResult?>((ref) => null);
