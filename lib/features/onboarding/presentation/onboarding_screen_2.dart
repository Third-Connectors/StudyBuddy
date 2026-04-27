import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/custom_progress_bar.dart';
import '../../../shared/widgets/custom_text_form_field.dart';
import '../../auth/data/repositories/auth_repository.dart';

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
class OnboardingScreen2 extends ConsumerStatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  ConsumerState<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends ConsumerState<OnboardingScreen2> {
  final _formKey = GlobalKey<FormState>();

  // ── Controllers ────────────────────────────────────────────────────────────
  final _namaController = TextEditingController();
  final _nisnController = TextEditingController();
  final _teleponController = TextEditingController();
  final _alamatController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

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
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
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

  Future<void> _onNextPressed() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = ref.read(authRepositoryProvider);

      // Register user dengan Supabase
      await authRepo.register(
        name: _namaController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        schoolName: null, // Bisa ditambahkan nanti
        gradeLevel: _selectedKelas?.replaceAll('Kelas ', ''),
      );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Registrasi berhasil! Selamat datang!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate based on class selection
        if (_isKelas12) {
          Navigator.of(context).pushNamed('/onboarding_ptn');
        } else {
          Navigator.of(context).pushNamed(
            '/vak_test',
            arguments: {'currentStep': 2, 'totalSteps': 3},
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);

        String errorMessage = 'Gagal mendaftar: $e';

        // Handle rate limit error
        if (e.toString().contains('over_email_send_rate_limit')) {
          errorMessage =
              'Terlalu banyak percobaan. Tunggu 1 menit lalu coba lagi, atau matikan email confirmation di Supabase dashboard.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryOrangeLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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

          const SizedBox(height: 14),

          // ── Password ─────────────────────────────────────────────────────
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Minimal 6 karakter',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: _togglePasswordVisibility,
              ),
              filled: true,
              fillColor: AppColors.primaryOrangeLighter,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent, width: 0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent, width: 0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primaryOrangeLight,
                  width: 1.5,
                ),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password wajib diisi';
              if (v.length < 6) return 'Password minimal 6 karakter';
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
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primaryOrangeLight,
                width: 1.5,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // "Already have account?" button
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
              child: RichText(
                text: TextSpan(
                  text: 'Sudah punya akun? ',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Login',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Next button with loading state
            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  disabledBackgroundColor: AppColors.darkGreen.withValues(
                    alpha: 0.55,
                  ),
                  foregroundColor: AppColors.textWhite,
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Row(
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
          ],
        ),
      ),
    );
  }
}
