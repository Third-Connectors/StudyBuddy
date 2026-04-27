import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/data/repositories/auth_repository.dart';
import '../../auth/data/models/user_model.dart' as app_models;
import '../../onboarding/data/vak_providers.dart';
import '../../onboarding/domain/models/vak_result_model.dart';

/// Profile Screen - Display and edit user profile.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  app_models.UserModel? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.getProfile();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat profil: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange));
    }

    if (_error != null) {
      return _buildErrorView();
    }

    final vakResult = ref.watch(savedVakResultProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Screen Title ───────────────────────────────────────
            Text(
              'Profile',
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            // ── 2. Profile Header Card ────────────────────────────────
            _buildProfileHeader(context),
            const SizedBox(height: 24),

            // ── 3. Learning Style (VAK) ───────────────────────────────
            _buildLearningStyleCard(vakResult),
            const SizedBox(height: 24),

            // ── 4. Quick Stats ────────────────────────────────────────
            _buildStatsOverview(),
            const SizedBox(height: 24),

            // ── 5. Menu Items ─────────────────────────────────────────
            _buildMenuItems(),
            const SizedBox(height: 24),

            // ── 6. Logout ─────────────────────────────────────────────
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryOrange),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryOrange, Color(0xFFFB923C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 4),
            ),
            child: Center(
              child: Text(
                _user?.name.substring(0, 1).toUpperCase() ?? 'S',
                style: GoogleFonts.nunito(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _user?.name ?? 'Student',
            style: GoogleFonts.nunito(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_user?.schoolName ?? 'SMA Unggulan'} • Kelas ${_user?.gradeLevel ?? '12'}',
            style: GoogleFonts.nunito(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningStyleCard(VakResult? result) {
    final styleName = result?.dominantStyleLabel ?? 'Belum Tes';
    final styleEmoji = result?.dominantStyleEmoji ?? '❓';
    final styleDesc = result != null 
        ? 'Kamu belajar paling efektif dengan gaya ${result.dominantStyleLabel.toLowerCase()}.' 
        : 'Temukan gaya belajarmu untuk hasil yang lebih maksimal!';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(styleEmoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gaya Belajar',
                      style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      styleName,
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Reset VAK state before retaking
                  ref.read(vakCurrentIndexProvider.notifier).state = 0;
                  ref.read(vakAnswersProvider.notifier).state = {};
                  Navigator.of(context).pushNamed(
                    '/vak_test',
                    arguments: {'currentStep': 1, 'totalSteps': 1},
                  );
                },
                child: Text(
                  result == null ? 'Mulai Tes' : 'Tes Ulang',
                  style: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: AppColors.primaryOrange),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            styleDesc,
            style: GoogleFonts.nunito(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Row(
      children: [
        Expanded(child: _buildStatItem(Icons.quiz_rounded, '12', 'Quiz Selesai')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem(Icons.bolt_rounded, '1,250', 'Total XP')),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem(Icons.stars_rounded, '85%', 'Rata-rata')),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryOrange, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: GoogleFonts.nunito(color: AppColors.textLight, fontSize: 10, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.history_rounded, 'Riwayat Belajar'),
          _divider(),
          _buildMenuItem(Icons.badge_outlined, 'Pencapaian'),
          _divider(),
          _buildMenuItem(Icons.notifications_none_rounded, 'Notifikasi'),
          _divider(),
          _buildMenuItem(Icons.settings_outlined, 'Pengaturan Akun'),
          _divider(),
          _buildMenuItem(Icons.help_outline_rounded, 'Bantuan & FAQ'),
        ],
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: AppColors.divider, indent: 20, endIndent: 20);

  Widget _buildMenuItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => _showLogoutDialog(),
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
        label: Text(
          'Keluar dari Akun',
          style: GoogleFonts.nunito(
            color: Colors.redAccent,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: Colors.redAccent.withOpacity(0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Logout?', style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
        content: Text('Apakah kamu yakin ingin keluar?', style: GoogleFonts.nunito()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.nunito(color: AppColors.textLight)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final authRepo = ref.read(authRepositoryProvider);
              await authRepo.logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/onboarding1', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }
}
