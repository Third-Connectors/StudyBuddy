import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_progress_bar.dart';
import '../data/study_providers.dart';
import 'practice_screen.dart';

class SubjectDetailsScreen extends ConsumerWidget {
  final String subjectName;
  final IconData icon;
  final Color iconColor;

  const SubjectDetailsScreen({
    super.key,
    required this.subjectName,
    required this.icon,
    required this.iconColor,
  });

  // Generasikan daftar bab materi secara dinamis berdasarkan mata pelajaran
  List<String> _getChapters() {
    final upper = subjectName.toUpperCase();
    if (upper.contains('SB') || upper.contains('SENI')) {
      return [
        'Bab 1: Konsep Seni Rupa Dua Dimensi',
        'Bab 2: Teknik & Unsur Karya Seni Rupa',
        'Bab 3: Apresiasi Seni Rupa Nusantara',
        'Bab 4: Pengenalan Alat & Bahan Melukis',
        'Bab 5: Pameran Seni Rupa Sekolah',
      ];
    } else if (upper.contains('ING') || upper.contains('ENG') || upper.contains('EL')) {
      return [
        'Bab 1: Analytical Exposition Text',
        'Bab 2: Conditional Sentences Type 1, 2, & 3',
        'Bab 3: Passive Voice in Various Tenses',
        'Bab 4: Reading Comprehension & Main Idea',
        'Bab 5: Discussion Text Writing',
      ];
    } else if (upper.contains('AL') || upper.contains('MTK') || upper.contains('MW') || upper.contains('MAT')) {
      return [
        'Bab 1: Persamaan & Pertidaksamaan Nilai Mutlak',
        'Bab 2: Program Linear & Model Matematika',
        'Bab 3: Matriks & Transformasi Geometri',
        'Bab 4: Turunan Fungsi Aljabar',
        'Bab 5: Integral Parsial & Luas Daerah',
      ];
    } else if (upper.contains('GEO')) {
      return [
        'Bab 1: Konsep Dasar Ilmu Geografi',
        'Bab 2: Peta, Pengindraan Jauh, & SIG',
        'Bab 3: Dinamika Planet Bumi & Jagat Raya',
        'Bab 4: Dinamika Litosfer & Dampak Terhadap Kehidupan',
        'Bab 5: Dinamika Atmosfer & Pengaruh Iklim',
      ];
    } else if (upper.contains('SOS')) {
      return [
        'Bab 1: Perubahan Sosial di Masyarakat',
        'Bab 2: Globalisasi & Dampak Sosialnya',
        'Bab 3: Ketimpangan Sosial dalam Pembangunan',
        'Bab 4: Konflik Sosial & Resolusi Konflik',
        'Bab 5: Kearifan Lokal & Pemberdayaan Komunitas',
      ];
    } else if (upper.contains('PAI') || upper.contains('AGAMA')) {
      return [
        'Bab 1: Berpikir Kritis & Bersikap Demokratis',
        'Bab 2: Saling Menasihati dalam Kebajikan',
        'Bab 3: Indahnya Menjalin Ukhuwah & Toleransi',
        'Bab 4: Sejarah Kebudayaan Islam di Indonesia',
        'Bab 5: Meniti Hidup dengan Kemuliaan Akhlak',
      ];
    } else if (upper.contains('BK')) {
      return [
        'Bab 1: Pengenalan Minat & Bakat Karir',
        'Bab 2: Perencanaan Kuliah & Dunia Kerja',
        'Bab 3: Manajemen Waktu Belajar Efektif',
        'Bab 4: Kesehatan Mental & Regulasi Emosi',
        'Bab 5: Membangun Rasa Percaya Diri',
      ];
    } else if (upper.contains('PKWU') || upper.contains('PKW')) {
      return [
        'Bab 1: Kewirausahaan & Karakter Wirausaha',
        'Bab 2: Perencanaan Usaha Produk Kreatif',
        'Bab 3: Perhitungan Biaya Produksi & Harga Jual',
        'Bab 4: Teknik Promosi & Pemasaran Produk',
        'Bab 5: Laporan Keuangan Sederhana',
      ];
    } else if (upper.contains('BIN') || upper.contains('IND')) {
      return [
        'Bab 1: Menyusun Surat Lamaran Pekerjaan',
        'Bab 2: Menikmati Cerita Sejarah Indonesia',
        'Bab 3: Memahami Teks Editorial & Opini',
        'Bab 4: Menilai Karya Melalui Kritik & Esai',
        'Bab 5: Menulis Artikel Ilmiah Populer',
      ];
    } else if (upper.contains('SEJ')) {
      return [
        'Bab 1: Konsep Dasar Ilmu Sejarah',
        'Bab 2: Zaman Praaksara di Indonesia',
        'Bab 3: Masuknya Hindu-Buddha & Kerajaan Besar',
        'Bab 4: Lahirnya Pergerakan Nasional Indonesia',
        'Bab 5: Proklamasi Kemerdekaan & Sidang PPKI',
      ];
    } else if (upper.contains('PPKN') || upper.contains('PPK')) {
      return [
        'Bab 1: Kasus Pelanggaran Hak & Pengingkaran Kewajiban',
        'Bab 2: Perlindungan & Penegakan Hukum di Indonesia',
        'Bab 3: Pengaruh Kemajuan IPTEK Terhadap NKRI',
        'Bab 4: Dinamika Persatuan & Kesatuan Bangsa',
        'Bab 5: Strategi Mengatasi Ancaman Terhadap Negara',
      ];
    } else if (upper.contains('PJOK') || upper.contains('OR')) {
      return [
        'Bab 1: Teknik Dasar Permainan Bola Besar',
        'Bab 2: Teknik Dasar Permainan Bola Kecil',
        'Bab 3: Atletik & Jalan Cepat',
        'Bab 4: Pencak Silat & Bela Diri',
        'Bab 5: Kebugaran Jasmani & Pengukuran Indeks Massa Tubuh',
      ];
    } else if (upper.contains('KIM') || upper.contains('CHEM')) {
      return [
        'Bab 1: Sifat Koligatif Larutan',
        'Bab 2: Reaksi Redoks & Sel Elektrokimia',
        'Bab 3: Kimia Unsur & Senyawa Kompleks',
        'Bab 4: Kimia Karbon & Makromolekul',
        'Bab 5: Termokimia & Laju Reaksi',
      ];
    } else if (upper.contains('FIS') || upper.contains('PHY')) {
      return [
        'Bab 1: Listrik Statis & Listrik Dinamis',
        'Bab 2: Medan Magnetik & Induksi Elektromagnetik',
        'Bab 3: Gelombang Cahaya & Teori Relativitas',
        'Bab 4: Fisika Inti & Radioaktivitas',
        'Bab 5: Mekanika Fluida & Termodinamika',
      ];
    } else if (upper.contains('BIO')) {
      return [
        'Bab 1: Pertumbuhan & Perkembangan Tumbuhan',
        'Bab 2: Metabolisme Sel & Enzim',
        'Bab 3: Genetika & Pewarisan Sifat (Mendel)',
        'Bab 4: Teori Evolusi & Seleksi Alam',
        'Bab 5: Bioteknologi Modern & Rekayasa Genetika',
      ];
    } else if (upper.contains('EKO') || upper.contains('ACT')) {
      return [
        'Bab 1: Akuntansi sebagai Sistem Informasi',
        'Bab 2: Persamaan Dasar Akuntansi & Jurnal Umum',
        'Bab 3: Siklus Akuntansi Perusahaan Jasa',
        'Bab 4: Siklus Akuntansi Perusahaan Dagang',
        'Bab 5: Manajemen & Koperasi Sekolah',
      ];
    }

    // Generator Nama Pelajaran Dinamis untuk mencegah placeholder statis sama sekali!
    return [
      'Bab 1: Konsep Dasar & Teori Utama $subjectName',
      'Bab 2: Struktur, Klasifikasi, & Pola $subjectName',
      'Bab 3: Analisis Kasus & Implementasi Nyata $subjectName',
      'Bab 4: Eksperimen & Pemecahan Soal Komposit $subjectName',
      'Bab 5: Evaluasi Akhir & Penguatan Pemahaman $subjectName',
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapters = _getChapters();
    final completedMap = ref.watch(completedChaptersProvider);
    final completedSet = completedMap[subjectName] ?? {};
    
    final progress = chapters.isEmpty ? 0.0 : (completedSet.length / chapters.length);
    final percentLabel = '${(progress * 100).round()}%';

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(subjectName, style: AppTextStyles.titleMedium),
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header Card: Progress Indicator ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: iconColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: iconColor, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Progres Belajarmu',
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${completedSet.length} dari ${chapters.length} Bab Selesai Dibaca',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          percentLabel,
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: progress == 0.0 ? AppColors.textLight : iconColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    CustomProgressBar(
                      progress: progress,
                      height: 8,
                      activeColor: progress == 0.0 ? AppColors.textLight : iconColor,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Quick Practice CTA ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF7ED), Color(0xFFFFF1F2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryOrangeLight, width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.quiz_rounded, color: AppColors.primaryOrange, size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Uji Pemahamanmu!',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Kerjakan latihan soal dinamis dengan Socratic AI.',
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PracticeScreen(subject: subjectName),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Latihan',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Section Title: Daftar Materi ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 10),
              child: Text(
                'Daftar Materi & Bab',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          // ── Chapters List ────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.separated(
              itemCount: chapters.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final isCompleted = completedSet.contains(index);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isCompleted ? iconColor.withOpacity(0.5) : AppColors.divider,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chapters[index],
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                  size: 14,
                                  color: isCompleted ? iconColor : AppColors.textLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isCompleted ? 'Selesai dibaca' : 'Belum dibaca',
                                  style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isCompleted ? iconColor : AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          if (isCompleted) {
                            ref.read(completedChaptersProvider.notifier).toggleChapter(subjectName, index);
                          } else {
                            _showEmptyChapterDialog(context, ref, index, chapters[index]);
                          }
                        },
                        icon: Icon(
                          isCompleted ? Icons.undo_rounded : Icons.chrome_reader_mode_rounded,
                          size: 16,
                          color: isCompleted ? AppColors.textSecondary : iconColor,
                        ),
                        label: Text(
                          isCompleted ? 'Reset' : 'Baca',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: isCompleted ? AppColors.textSecondary : iconColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  void _showEmptyChapterDialog(BuildContext context, WidgetRef ref, int index, String chapterTitle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surfaceWhite,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primaryOrangeLighter,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.primaryOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Materi Belum Siap',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chapterTitle,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Materi bacaan lengkap untuk bab ini sedang disiapkan oleh tim kurikulum StudyBuddy. Tenang saja, materi latihan soal di menu Latihan sudah bisa kamu kerjakan!',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Apakah kamu ingin menandai bab ini sebagai SELESAI dibaca untuk meningkatkan progres belajarmu?',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(completedChaptersProvider.notifier).toggleChapter(subjectName, index);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: Text(
              'Tandai Selesai',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
