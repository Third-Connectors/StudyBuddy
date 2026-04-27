// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_text_form_field.dart';
import '../data/repositories/auth_repository.dart';

/// Login screen for Study Buddy.
///
/// Uses [ConsumerStatefulWidget] so it can own local form state (controllers,
/// obscure-text toggle, form key) while simultaneously watching the global
/// [authProvider] from Riverpod.
///
/// Navigation:
///   • Successful login  → pushNamedAndRemoveUntil('/home')
///   • "Daftar" link     → pushNamedAndRemoveUntil('/onboarding1')
///   • "Lupa password?"  → (placeholder — wire up when screen exists)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // ── Form infrastructure ──────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _onLoginPressed() async {
    // Dismiss keyboard before processing
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final authRepo = ref.read(authRepositoryProvider);
        await authRepo.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        // Navigate to home on success
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } catch (e) {
        String errorMessage = e.toString();
        
        // Map Supabase errors to user-friendly Indonesian messages
        if (errorMessage.contains('email_not_confirmed')) {
          errorMessage = 'Email belum dikonfirmasi. Silakan cek inbox/spam email Anda untuk verifikasi.';
        } else if (errorMessage.contains('Invalid login credentials')) {
          errorMessage = 'Email atau password salah.';
        } else if (errorMessage.contains('Network') || errorMessage.contains('SocketException')) {
          errorMessage = 'Koneksi internet bermasalah. Silakan coba lagi.';
        } else {
          errorMessage = 'Terjadi kesalahan saat login.';
        }
        
        // Show error
        _showErrorSnackBar(errorMessage);
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  // ── Email validator ───────────────────────────────────────────────────────

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }
    final emailRegex = RegExp(r'^[\w\.\-\+]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // ── Password validator ────────────────────────────────────────────────────

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Top hero section (~35 % of screen height) ────────────
                _HeroSection(height: screenHeight * 0.35),

                // ── Welcome heading ───────────────────────────────────────
                Text(
                  'Selamat Datang Kembali! 👋',
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Masuk untuk melanjutkan belajarmu',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Email field ───────────────────────────────────────────
                CustomTextFormField(
                  label: 'Email',
                  hintText: 'email@example.com',
                  isRequired: true,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 14),

                // ── Password field ────────────────────────────────────────
                CustomTextFormField(
                  label: 'Password',
                  hintText: '••••••••',
                  isRequired: true,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: _validatePassword,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    splashRadius: 20,
                    onPressed: _togglePasswordVisibility,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Forgot password link ──────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            // TODO: Navigate to ForgotPasswordScreen when created
                            // Navigator.pushNamed(context, '/forgot-password');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Fitur reset password segera hadir!',
                                  style: GoogleFonts.nunito(fontSize: 13),
                                ),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Lupa password?',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Primary login button ──────────────────────────────────
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      disabledBackgroundColor: AppColors.darkGreen.withValues(
                        alpha: 0.55,
                      ),
                      foregroundColor: AppColors.textWhite,
                      shape: const StadiumBorder(),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isLoading
                          ? const SizedBox(
                              key: ValueKey('loader'),
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.textWhite,
                              ),
                            )
                          : Text(
                              'Masuk →',
                              key: const ValueKey('label'),
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Register link ─────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () {
                              Navigator.pushNamed(context, '/onboarding1');
                            },
                      child: Text(
                        'Daftar',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _isLoading
                              ? AppColors.primaryOrange.withOpacity(0.45)
                              : AppColors.primaryOrange,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// _HeroSection — top branding block
// ═════════════════════════════════════════════════════════════════════════════

/// Displays the large book emoji and "Study Buddy" wordmark centred inside a
/// container of [height] pixels (typically ~35 % of screen height).
class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Emoji icon ─────────────────────────────────────────────────
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primaryOrangeLighter,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryOrangeLight, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text('📚', style: TextStyle(fontSize: 42)),
            ),
          ),

          const SizedBox(height: 16),

          // ── Wordmark ───────────────────────────────────────────────────
          Text(
            'Study Buddy',
            style: GoogleFonts.nunito(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryOrange,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Belajar lebih cerdas, bukan lebih keras',
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
