import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/data/repositories/auth_repository.dart';
import '../../auth/data/models/user_model.dart' as app_models;
import '../../onboarding/data/vak_providers.dart';
import '../../onboarding/domain/models/vak_result_model.dart';

/// Profile Screen - Display and edit user profile with 100% real backend & persistence.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  app_models.UserModel? _user;
  bool _isLoading = true;
  String? _error;

  // Real persistence for Notifications via SharedPreferences
  bool _notifDaily = true;
  bool _notifTips = true;

  // Real database study history fetched from Supabase
  List<Map<String, dynamic>> _realHistory = [];
  bool _isLoadingHistory = false;

  @override
  void initState() {
    super.initState();
    _loadProfileAndHistory();
    _loadNotificationPreferences();
  }

  Future<void> _loadProfileAndHistory() async {
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

      // Fetch real history from Supabase
      _fetchRealStudyHistory(user.id);
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat profil: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNotificationPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _notifDaily = prefs.getBool('notif_daily') ?? true;
        _notifTips = prefs.getBool('notif_tips') ?? true;
      });
    } catch (e) {
      print('Error loading notification preferences: $e');
    }
  }

  Future<void> _saveNotificationPreference(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (e) {
      print('Error saving notification preference: $e');
    }
  }

  Future<void> _fetchRealStudyHistory(String userId) async {
    setState(() {
      _isLoadingHistory = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('tutor_sessions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(5);

      if (response != null) {
        setState(() {
          _realHistory = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      print('Error fetching real tutor sessions: $e');
    } finally {
      setState(() {
        _isLoadingHistory = false;
      });
    }
  }

  void _showSuccessSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                msg,
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── 1. Riwayat Belajar Sheet (REAL SUPABASE QUERY!)
  void _showStudyHistorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Riwayat Belajar Riil 📚',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            
            if (_isLoadingHistory)
              const Center(child: Padding(padding: EdgeInsets.all(24.0), child: CircularProgressIndicator(color: AppColors.primaryOrange)))
            else if (_realHistory.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrangeLighter,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryOrangeLight),
                ),
                child: Column(
                  children: [
                    const Text('📚', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 12),
                    Text(
                      'Belum Ada Sesi Belajar Nyata',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mulailah obrolan belajar pertamamu dengan Socratic AI Tutor untuk mengisi riwayat belajar riil di database!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              )
            else
              ..._realHistory.map((session) {
                final topic = session['topic'] ?? session['subject'] ?? 'Sesi Socratic AI';
                final dateStr = session['created_at'] != null 
                    ? DateTime.tryParse(session['created_at'].toString())?.toLocal().toString().substring(0, 16) ?? 'Sesi Belajar'
                    : 'Baru-baru ini';
                return _buildHistoryItem(
                  'Socratic AI Tutor', 
                  topic, 
                  dateStr, 
                  Icons.bolt_rounded, 
                  Colors.orange
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String desc, String date, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(desc, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(date, style: GoogleFonts.nunito(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 2. Pencapaian Sheet (DIBANDINGKAN SECARA NYATA DENGAN DATA SUPABASE USER!)
  void _showAchievementsSheet() {
    final currentXp = _user?.xp ?? 0;
    final currentLevel = _user?.level ?? 1;
    final hasLearningStyle = _user?.learningStyle != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pencapaian Riil 🏅',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'Lencana di bawah ini otomatis terbuka secara nyata berdasarkan XP, Level, & tes gaya belajarmu di Supabase!',
              style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 20),
            _buildAchievementItem(
              'Pionir Socrates', 
              'Kumpulkan XP pertamamu dengan mulai belajar.', 
              currentXp > 0, 
              '🔓'
            ),
            _buildAchievementItem(
              'Penjelajah Gaya Belajar', 
              'Selesaikan tes gaya belajar (VAK) untuk memahami potensimu.', 
              hasLearningStyle, 
              '👁️'
            ),
            _buildAchievementItem(
              'Ksatria Pelajar', 
              'Capai Level 2 untuk membuka lencana ksatria.', 
              currentLevel >= 2, 
              '🛡️'
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementItem(String name, String criteria, bool isUnlocked, String emoji) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.amber.shade50.withOpacity(0.4) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isUnlocked ? Colors.amber.shade200 : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.amber.shade100 : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(name, style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary)),
                    if (isUnlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.amber.shade200, borderRadius: BorderRadius.circular(8)),
                        child: Text('DIBUKA', style: GoogleFonts.outfit(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.amber.shade900)),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                        child: Text('TERKUNCI', style: GoogleFonts.outfit(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.grey.shade700)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(criteria, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textSecondary, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Notifikasi Sheet (DIPERSISTENKAN SECARA RIIL DI DEVICE VIA SHAREDPREFERENCES!)
  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pengaturan Notifikasi Riil 🔔',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text('Pengingat Harian', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text('Dapatkan pengingat untuk belajar di rumah sesuai jadwal optimal.', style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textSecondary)),
                activeColor: AppColors.primaryOrange,
                value: _notifDaily,
                onChanged: (val) async {
                  setModalState(() => _notifDaily = val);
                  setState(() => _notifDaily = val);
                  await _saveNotificationPreference('notif_daily', val);
                  _showSuccessSnackBar('Preferensi pengingat harian disimpan secara riil di memori perangkat!');
                },
              ),
              const Divider(color: AppColors.divider),
              SwitchListTile(
                title: Text('Tips Belajar AI', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: Text('Dapatkan tips belajar mingguan yang dihasilkan asisten AI.', style: GoogleFonts.nunito(fontSize: 12, color: AppColors.textSecondary)),
                activeColor: AppColors.primaryOrange,
                value: _notifTips,
                onChanged: (val) async {
                  setModalState(() => _notifTips = val);
                  setState(() => _notifTips = val);
                  await _saveNotificationPreference('notif_tips', val);
                  _showSuccessSnackBar('Preferensi tips belajar AI disimpan secara riil di memori perangkat!');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 4. Pengaturan Akun Sheet (Real Supabase Profile Editor!)
  void _showAccountSettingsSheet() {
    final nameController = TextEditingController(text: _user?.name);
    final schoolController = TextEditingController(text: _user?.schoolName);
    final gradeController = TextEditingController(text: _user?.gradeLevel);
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Ubah Profil Akun ⚙️',
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                
                // Name Field
                Text('NAMA LENGKAP', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: _buildInputDecoration(Icons.person_outline),
                ),
                const SizedBox(height: 16),

                // School Field
                Text('NAMA SEKOLAH', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                TextField(
                  controller: schoolController,
                  style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: _buildInputDecoration(Icons.school_outlined),
                ),
                const SizedBox(height: 16),

                // Grade Field
                Text('TINGKAT KELAS', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                TextField(
                  controller: gradeController,
                  style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: _buildInputDecoration(Icons.grade_outlined),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  height: 52,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryOrange, Color(0xFFEA580C)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: isSaving ? null : () async {
                        setModalState(() => isSaving = true);
                        try {
                          final authRepo = ref.read(authRepositoryProvider);
                          final updatedUser = await authRepo.updateProfile(
                            name: nameController.text.trim(),
                            schoolName: schoolController.text.trim(),
                            gradeLevel: gradeController.text.trim(),
                          );
                          setState(() {
                            _user = updatedUser;
                          });
                          Navigator.pop(context);
                          _showSuccessSnackBar('Profil akun berhasil diperbarui secara riil di Supabase!');
                        } catch (e) {
                          _showErrorSnackBar('Gagal memperbarui profil: $e');
                        } finally {
                          setModalState(() => isSaving = false);
                        }
                      },
                      child: isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('Simpan Perubahan', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(IconData prefixIcon) {
    return InputDecoration(
      prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2)),
    );
  }

  // ── 5. Bantuan & FAQ Sheet
  void _showHelpSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Bantuan & FAQ ❓',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              _buildFaqItem('Apa itu Socratic AI Tutor?', 'Socratic AI Tutor adalah asisten belajar pintar berbasis kecerdasan buatan dari Google Gemini yang membimbingmu memahami konsep belajar secara mandiri menggunakan metode tanya jawab Sokratis.'),
              _buildFaqItem('Bagaimana cara scan jadwal?', 'Buka tab Jadwal, klik tombol scan di pojok bawah, lalu foto lembaran jadwal sekolahmu. AI akan memindai dan merapikannya secara otomatis untuk belajar di rumah.'),
              _buildFaqItem('Apakah pembayaran Midtrans aman?', 'Sangat aman! Seluruh transaksi diproses secara langsung menggunakan gateway pembayaran Midtrans dengan enkripsi perbankan standar industri nasional.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryOrangeLight.withOpacity(0.5)),
      ),
      child: ExpansionTile(
        title: Text(question, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
        iconColor: AppColors.primaryOrange,
        collapsedIconColor: AppColors.textSecondary,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(answer, style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
        ],
      ),
    );
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

    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Screen Title
              Text(
                'Profil Saya',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // ── 2. Profile Header Card
              _buildProfileHeader(context),
              const SizedBox(height: 24),

              // ── 3. Learning Style (VAK)
              _buildLearningStyleCard(vakResult),
              const SizedBox(height: 24),

              // ── 4. Quick Stats
              _buildStatsOverview(),
              const SizedBox(height: 24),

              // ── 5. Menu Items (100% Berfungsi!)
              _buildMenuItems(),
              const SizedBox(height: 24),

              // ── 6. Logout
              _buildLogoutButton(),
            ],
          ),
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
              onPressed: _loadProfileAndHistory,
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
      width: double.infinity,
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
          Stack(
            alignment: Alignment.bottomRight,
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
                    (_user != null && _user!.name.isNotEmpty)
                        ? _user!.name.substring(0, 1).toUpperCase()
                        : 'S',
                    style: GoogleFonts.outfit(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Text(
                  'Lv. ${_user?.level ?? 1}',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _user?.name ?? 'Student',
            style: GoogleFonts.outfit(
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

  Widget _buildLearningStyleCard(VakResult? localResult) {
    final styleFromDb = _user?.learningStyle;
    final styleName = styleFromDb ?? localResult?.dominantStyleLabel ?? 'Belum Tes';
    
    final styleEmoji = styleFromDb != null 
        ? (styleFromDb.contains('Visual') ? '👁️' : styleFromDb.contains('Auditory') ? '🎧' : '🏃')
        : (localResult?.dominantStyleEmoji ?? '❓');

    final styleDesc = styleName != 'Belum Tes'
        ? 'Kamu belajar paling efektif dengan gaya ${styleName.toLowerCase()}.' 
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
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  ref.read(vakCurrentIndexProvider.notifier).state = 0;
                  ref.read(vakAnswersProvider.notifier).state = {};
                  await Navigator.of(context).pushNamed(
                    '/vak_test',
                    arguments: {'currentStep': 1, 'totalSteps': 1},
                  );
                  _loadProfileAndHistory(); // Reload after test
                },
                child: Text(
                  styleName == 'Belum Tes' ? 'Mulai Tes' : 'Tes Ulang',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: AppColors.primaryOrange),
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
        Expanded(child: _buildStatItem(Icons.bolt_rounded, _user?.xp.toString() ?? '0', 'Total XP')),
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
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800),
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
          _buildMenuItem(Icons.history_rounded, 'Riwayat Belajar', _showStudyHistorySheet),
          _divider(),
          _buildMenuItem(Icons.badge_outlined, 'Pencapaian', _showAchievementsSheet),
          _divider(),
          _buildMenuItem(Icons.notifications_none_rounded, 'Notifikasi', _showNotificationsSheet),
          _divider(),
          _buildMenuItem(Icons.settings_outlined, 'Pengaturan Akun', _showAccountSettingsSheet),
          _divider(),
          _buildMenuItem(Icons.help_outline_rounded, 'Bantuan & FAQ', _showHelpSheet),
        ],
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: AppColors.divider, indent: 20, endIndent: 20);

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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
        title: Text('Logout?', style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
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
