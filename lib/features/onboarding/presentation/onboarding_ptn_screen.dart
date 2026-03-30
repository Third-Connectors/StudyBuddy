import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_progress_bar.dart';

/// Onboarding Step 2-of-4 — hanya muncul untuk siswa **Kelas 12**.
///
/// Mengajak siswa menetapkan target PTN (universitas & jurusan impian)
/// sehingga fitur persiapan SNBT dapat dipersonalisasi.
///
/// Alur navigasi:
/// - Masuk  : dari [OnboardingScreen2] ketika kelas = "Kelas 12"
/// - Keluar : ke [MainNavigationScreen] (`/home`), back-stack dibersihkan
class OnboardingPtnScreen extends StatefulWidget {
  const OnboardingPtnScreen({super.key});

  @override
  State<OnboardingPtnScreen> createState() => _OnboardingPtnScreenState();
}

class _OnboardingPtnScreenState extends State<OnboardingPtnScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedUniversitas;
  String? _selectedJurusan;

  // ── Data Lists ─────────────────────────────────────────────────────────────

  static const List<String> _universitasList = [
    'Universitas Indonesia (UI)',
    'Institut Teknologi Bandung (ITB)',
    'Universitas Gadjah Mada (UGM)',
    'Universitas Airlangga (UNAIR)',
    'Institut Pertanian Bogor (IPB)',
    'Institut Teknologi Sepuluh Nopember (ITS)',
    'Universitas Diponegoro (UNDIP)',
    'Universitas Padjadjaran (UNPAD)',
    'Universitas Brawijaya (UB)',
    'Universitas Sebelas Maret (UNS)',
    'Universitas Negeri Yogyakarta (UNY)',
    'Universitas Hasanuddin (UNHAS)',
    'Universitas Sumatera Utara (USU)',
    'Universitas Pendidikan Indonesia (UPI)',
    'Universitas Negeri Semarang (UNNES)',
    'Universitas Negeri Malang (UM)',
    'Universitas Lampung (UNILA)',
    'Universitas Sriwijaya (UNSRI)',
    'Universitas Andalas (UNAND)',
    'Universitas Udayana (UNUD)',
  ];

  static const List<String> _jurusanList = [
    'Kedokteran',
    'Kedokteran Gigi',
    'Farmasi',
    'Kesehatan Masyarakat',
    'Ilmu Keperawatan',
    'Ilmu Gizi',
    'Teknik Informatika',
    'Ilmu Komputer',
    'Sistem Informasi',
    'Teknik Elektro',
    'Teknik Sipil',
    'Teknik Mesin',
    'Teknik Kimia',
    'Teknik Industri',
    'Arsitektur',
    'Statistika',
    'Matematika',
    'Fisika',
    'Kimia',
    'Biologi',
    'Akuntansi',
    'Manajemen',
    'Ekonomi Pembangunan',
    'Hukum',
    'Psikologi',
    'Ilmu Komunikasi',
    'Hubungan Internasional',
    'Ilmu Politik',
    'Sosiologi',
    'Pendidikan Bahasa Inggris',
    'Pendidikan Matematika',
  ];

  // ── Computed helpers ───────────────────────────────────────────────────────

  /// Langkah ini selalu step 2 dari total 4 langkah.
  static const double _progress = 2 / 4; // 50 %

  // ── Actions ────────────────────────────────────────────────────────────────

  void _onNextPressed() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // TODO: simpan _selectedUniversitas & _selectedJurusan ke provider / repo
      // sebelum melanjutkan ke home.
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      bottomNavigationBar: _buildBottomButton(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepHeader(),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Form(key: _formKey, child: _buildFormCard()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step Progress Header ────────────────────────────────────────────────────

  Widget _buildStepHeader() {
    final int stepPercent = (_progress * 100).toInt(); // 50

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Langkah 2 dari 4',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                '$stepPercent%',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const CustomProgressBar(progress: _progress, height: 6),
        ],
      ),
    );
  }

  // ── Form Card ──────────────────────────────────────────────────────────────

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ───────────────────────────────────────────────────
          Text('Target Perguruan Tinggi', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Tetapkan universitas & jurusan impianmu',
            style: AppTextStyles.bodySmall,
          ),

          const SizedBox(height: 20),

          // ── Info Card ─────────────────────────────────────────────────────
          _buildInfoCard(),

          const SizedBox(height: 24),

          // ── Universitas Impian ────────────────────────────────────────────
          _buildDropdownField(
            label: 'Universitas Impian',
            hint: 'Pilih universitas',
            items: _universitasList,
            initialValue: _selectedUniversitas,
            onChanged: (v) => setState(() => _selectedUniversitas = v),
            validator: (v) =>
                v == null ? 'Universitas impian wajib dipilih' : null,
          ),

          const SizedBox(height: 14),

          // ── Jurusan Impian ────────────────────────────────────────────────
          _buildDropdownField(
            label: 'Jurusan Impian',
            hint: 'Pilih jurusan',
            items: _jurusanList,
            initialValue: _selectedJurusan,
            onChanged: (v) => setState(() => _selectedJurusan = v),
            validator: (v) => v == null ? 'Jurusan impian wajib dipilih' : null,
          ),
        ],
      ),
    );
  }

  // ── Info Card ───────────────────────────────────────────────────────────────

  /// Kartu informatif yang menjelaskan manfaat menetapkan target PTN.
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF), // light indigo tint
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              size: 18,
              color: Color(0xFF6366F1),
            ),
          ),

          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Text(
              'Sebagai siswa kelas 12, kamu bisa menetapkan target PTN. '
              'Ini akan membuka fitur persiapan SNBT khusus untukmu.',
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Dropdown Field ──────────────────────────────────────────────────────────

  /// Dropdown ber-style yang konsisten dengan form di [OnboardingScreen2].
  Widget _buildDropdownField({
    required String label,
    required String hint,
    required List<String> items,
    required String? initialValue,
    required ValueChanged<String?> onChanged,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label + required asterisk
        RichText(
          text: TextSpan(
            text: label,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: GoogleFonts.nunito(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        DropdownButtonFormField<String>(
          initialValue: initialValue,
          hint: Text(
            hint,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textLight,
            ),
          ),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
            size: 22,
          ),
          dropdownColor: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          menuMaxHeight: 320,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.primaryOrangeLighter,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primaryOrangeLight,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primaryOrangeLight,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primaryOrange,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
            errorStyle: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  // ── Bottom "Next" Button ────────────────────────────────────────────────────

  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              foregroundColor: AppColors.textWhite,
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Next',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: AppColors.textWhite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
