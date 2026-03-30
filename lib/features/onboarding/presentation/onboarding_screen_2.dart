import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_progress_bar.dart';
import '../../../shared/widgets/custom_text_form_field.dart';

/// Onboarding Step 1 — "Data Diri & Kelas" registration form.
///
/// Jumlah langkah bersifat **dinamis**:
/// - Kelas 10 / 11 → **3 langkah** total (progress 33 %)
/// - Kelas 12       → **4 langkah** total (progress 25 %), karena
///   langkah PTN disisipkan sebagai Langkah 2.
///
/// Navigasi saat "Next" ditekan:
/// - Kelas 12  → [OnboardingPtnScreen] (`/onboarding_ptn`)
/// - Selainnya → [MainNavigationScreen] (`/home`)
class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  final _formKey = GlobalKey<FormState>();

  // ── Controllers ────────────────────────────────────────────────────────────
  final _namaController = TextEditingController();
  final _nisnController = TextEditingController();
  final _teleponController = TextEditingController();
  final _alamatController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedKelas;

  static const List<String> _kelasList = ['Kelas 10', 'Kelas 11', 'Kelas 12'];

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _namaController.dispose();
    _nisnController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ── Computed helpers ────────────────────────────────────────────────────────

  /// Apakah kelas yang dipilih adalah Kelas 12.
  bool get _isKelas12 => _selectedKelas == 'Kelas 12';

  /// Total jumlah langkah onboarding berdasarkan kelas.
  int get _totalSteps => _isKelas12 ? 4 : 3;

  /// Nilai progress untuk step pertama (1 / totalSteps).
  double get _stepProgress => 1.0 / _totalSteps;

  /// Progress dalam persen, dibulatkan ke integer.
  int get _stepProgressPercent => (_stepProgress * 100).round();

  // ── Actions ────────────────────────────────────────────────────────────────

  void _onNextPressed() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      if (_isKelas12) {
        // Sisipkan langkah Target PTN sebelum melanjutkan ke home.
        Navigator.of(context).pushNamed('/onboarding_ptn');
      } else {
        // Langsung ke main app shell, bersihkan back-stack.
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      // ── Sticky Next Button ────────────────────────────────────────────────
      bottomNavigationBar: _buildBottomButton(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Step Progress Header ─────────────────────────────────────────
            _buildStepHeader(),

            // ── Scrollable Form Body ─────────────────────────────────────────
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Label berubah secara reaktif: "1 dari 3" ↔ "1 dari 4"
              Text(
                'Langkah 1 dari $_totalSteps',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              // Persentase ikut berubah: 33 % ↔ 25 %
              Text(
                '$_stepProgressPercent%',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar juga reaktif
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: CustomProgressBar(progress: _stepProgress, height: 6),
          ),
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
          Text('Data Diri & Kelas', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Lengkapi informasi dasar untuk memulai',
            style: AppTextStyles.bodySmall,
          ),

          const SizedBox(height: 24),

          // ── Nama Lengkap ──────────────────────────────────────────────────
          CustomTextFormField(
            label: 'Nama Lengkap',
            hintText: 'Masukkan nama lengkap',
            isRequired: true,
            controller: _namaController,
            keyboardType: TextInputType.name,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
          ),

          const SizedBox(height: 14),

          // ── NISN ──────────────────────────────────────────────────────────
          CustomTextFormField(
            label: 'NISN',
            hintText: 'Masukkan NISN',
            isRequired: true,
            controller: _nisnController,
            keyboardType: TextInputType.number,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'NISN wajib diisi' : null,
          ),

          const SizedBox(height: 14),

          // ── Kelas (Dropdown) ──────────────────────────────────────────────
          _buildKelasDropdown(),

          const SizedBox(height: 14),

          // ── No. Telepon ───────────────────────────────────────────────────
          CustomTextFormField(
            label: 'No. Telepon',
            hintText: '08xxxxxxxxxx',
            controller: _teleponController,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 14),

          // ── Alamat ────────────────────────────────────────────────────────
          CustomTextFormField(
            label: 'Alamat',
            hintText: 'Masukkan alamat',
            controller: _alamatController,
            maxLines: 2,
          ),

          const SizedBox(height: 14),

          // ── Email ─────────────────────────────────────────────────────────
          CustomTextFormField(
            label: 'Email',
            hintText: 'email@example.com',
            isRequired: true,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
              final emailRegex = RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              );
              if (!emailRegex.hasMatch(v.trim())) {
                return 'Format email tidak valid';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // ── Kelas Dropdown ──────────────────────────────────────────────────────────

  Widget _buildKelasDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label with required asterisk
        RichText(
          text: TextSpan(
            text: 'Kelas',
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
          initialValue: _selectedKelas,
          hint: Text(
            'Pilih kelas',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textLight,
            ),
          ),
          items: _kelasList.map((kelas) {
            return DropdownMenuItem<String>(
              value: kelas,
              child: Text(
                kelas,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedKelas = value),
          validator: (v) => v == null ? 'Kelas wajib dipilih' : null,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
            size: 22,
          ),
          dropdownColor: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
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
