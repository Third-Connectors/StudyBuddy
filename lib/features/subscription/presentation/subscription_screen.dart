// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../data/subscription_provider.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  SubscriptionTier _selectedTier = SubscriptionTier.reguler;
  String _selectedMethod = 'gopay';

  final List<Map<String, dynamic>> _payments = [
    {
      'id': 'gopay',
      'name': 'GoPay / QRIS (Midtrans)',
      'icon': Icons.qr_code_2_rounded,
      'color': const Color(0xFF00AED6)
    },
    {
      'id': 'shopeepay',
      'name': 'ShopeePay (Midtrans)',
      'icon': Icons.account_balance_wallet_rounded,
      'color': const Color(0xFFEE4D2D)
    },
    {
      'id': 'bca',
      'name': 'BCA Virtual Account (Midtrans)',
      'icon': Icons.account_balance_rounded,
      'color': const Color(0xFF005EAC)
    },
    {
      'id': 'cc',
      'name': 'Kartu Kredit (Midtrans)',
      'icon': Icons.credit_card_rounded,
      'color': const Color(0xFF4F46E5)
    },
  ];

  void _handlePayment() async {
    // Show Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primaryOrange, strokeWidth: 3),
              const SizedBox(height: 20),
              Text(
                'Menghubungkan ke API Midtrans...',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Membuat Enkripsi Transaksi Aman...',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Call Provider to Make Real Midtrans API Call
    await ref.read(subscriptionProvider.notifier).purchaseWithMidtrans(_selectedTier, _selectedMethod);
    final subState = ref.read(subscriptionProvider);

    if (mounted) {
      Navigator.of(context).pop(); // Dismiss Loading Dialog
      _showMidtransPortalSheet(subState);
    }
  }

  void _showMidtransPortalSheet(SubscriptionState subState) {
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
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Midtrans Logo Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GERBANG PEMBAYARAN',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal.shade200),
                    ),
                    child: Text(
                      'PROSES AMAN 256-BIT',
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.teal.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Konfirmasi Transaksi Midtrans',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // Transaction Info Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrangeLighter,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryOrangeLight),
                ),
                child: Column(
                  children: [
                    _buildPortalRow('Order ID:', subState.lastOrderId ?? 'STB-MOCK-123'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: AppColors.primaryOrangeLight),
                    ),
                    _buildPortalRow('Plan:', _selectedTier == SubscriptionTier.premium ? 'PREMIUM ACCESS' : 'REGULER ACCESS'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: AppColors.primaryOrangeLight),
                    ),
                    _buildPortalRow('Metode:', _payments.firstWhere((p) => p['id'] == _selectedMethod)['name']!),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: AppColors.primaryOrangeLight),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Bayar:',
                          style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          _selectedTier == SubscriptionTier.premium ? 'Rp 79.000' : 'Rp 49.000',
                          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryOrange),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Redirect URL Copy Section (Real Midtrans Link)
              if (subState.lastRedirectUrl != null) ...[
                Text(
                  'Tautan Pembayaran Aman (Klik untuk salin):',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: subState.lastRedirectUrl!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tautan pembayaran Midtrans berhasil disalin!', style: GoogleFonts.nunito(fontSize: 12)),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link_rounded, size: 18, color: AppColors.primaryOrange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            subState.lastRedirectUrl!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Icon(Icons.copy_all_rounded, size: 18, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Complete Simulation Button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup Portal Sheet
                    _showSuccessModal();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_user_rounded, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Selesaikan Pembayaran Instan',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '*Pembayaran terenkripsi penuh & otomatis mengaktifkan paket belajar Anda.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  void _showSuccessModal() {
    final isPremium = _selectedTier == SubscriptionTier.premium;
    final planName = isPremium ? 'PREMIUM' : 'REGULER';
    final planColor = isPremium ? Colors.amber : Colors.blue;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: planColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPremium ? Icons.workspace_premium_rounded : Icons.star_rounded,
                size: 72,
                color: planColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Selamat! Akunmu Menjadi $planName',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isPremium
                  ? 'Pembayaran via Midtrans sukses! Nikmati semua fitur premium StudyBuddy serta pembukaan instan materi SNBT tanpa batas harian sekarang juga.'
                  : 'Pembayaran via Midtrans sukses! Nikmati semua fitur reguler StudyBuddy termasuk Socratic AI Tutor & scan jadwal sepuasnya.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup modal sukses
                  Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                },
                child: Text(
                  'Mulai Belajar Sekarang',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Langganan StudyBuddy',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.amber, Color(0xFFD97706)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'PILIH PAKET BELAJARMU',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Text(
                'Buka Potensi Belajarmu!',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Two-Tier Selection (Reguler & Premium) ────────────────────
            Row(
              children: [
                // 🔹 REGULER CARD
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTier = SubscriptionTier.reguler),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _selectedTier == SubscriptionTier.reguler
                              ? AppColors.primaryOrange
                              : Colors.white,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _selectedTier == SubscriptionTier.reguler
                                ? AppColors.primaryOrange.withOpacity(0.12)
                                : Colors.black.withOpacity(0.02),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'REGULER',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.blue.shade700,
                                  letterSpacing: 1,
                                ),
                              ),
                              if (_selectedTier == SubscriptionTier.reguler)
                                const Icon(Icons.check_circle_rounded, color: AppColors.primaryOrange, size: 18),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Rp 49.000',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '/bulan',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 14),

                // 👑 PREMIUM CARD
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTier = SubscriptionTier.premium),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _selectedTier == SubscriptionTier.premium
                              ? AppColors.primaryOrange
                              : Colors.white,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _selectedTier == SubscriptionTier.premium
                                ? AppColors.primaryOrange.withOpacity(0.12)
                                : Colors.black.withOpacity(0.02),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PREMIUM',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.amber.shade700,
                                  letterSpacing: 1,
                                ),
                              ),
                              if (_selectedTier == SubscriptionTier.premium)
                                const Icon(Icons.check_circle_rounded, color: AppColors.primaryOrange, size: 18),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Rp 79.000',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '/bulan',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Benefit list based on tier selection ──────────────────────
            Text(
              'Yang Kamu Dapatkan:',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            _buildBenefitItem(
              Icons.bolt_rounded,
              _selectedTier == SubscriptionTier.premium ? Colors.amber : Colors.blue,
              'Socratic AI Tutor Sepuasnya',
              'Tanya jawab materi, penjelasan konsep, & penjelasan soal tanpa batas harian.'
            ),
            _buildBenefitItem(
              Icons.calendar_today_rounded,
              _selectedTier == SubscriptionTier.premium ? Colors.amber : Colors.blue,
              'Scan & Atur Jadwal Tanpa Batas',
              'Pindai jadwal sekolah tak terbatas & optimasikan otomatis untuk belajar di rumah.'
            ),
            _buildBenefitItem(
              _selectedTier == SubscriptionTier.premium ? Icons.workspace_premium_rounded : Icons.lock_outline_rounded,
              _selectedTier == SubscriptionTier.premium ? Colors.amber : AppColors.textLight,
              'Akses Modul SNBT Premium',
              _selectedTier == SubscriptionTier.premium 
                  ? 'Buka Instan modul latihan soal khusus Penalaran Matematika, Literasi, & Penalaran Umum.'
                  : 'Terkunci (Hanya terbuka gratis 1 semester sebelum UTBK).'
            ),
            _buildBenefitItem(
              _selectedTier == SubscriptionTier.premium ? Icons.star_rounded : Icons.lock_outline_rounded,
              _selectedTier == SubscriptionTier.premium ? Colors.amber : AppColors.textLight,
              'Tanpa Iklan & Prioritas AI',
              _selectedTier == SubscriptionTier.premium 
                  ? 'Belajar lancar tanpa iklan, server AI prioritas tinggi super cepat.'
                  : 'Terkunci (Hanya tersedia di paket Premium).'
            ),

            const SizedBox(height: 24),

            // ── Payment Selection ──────────────────────────────────────────
            Text(
              'Pilih Metode Pembayaran:',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            ..._payments.map((p) => GestureDetector(
              onTap: () => setState(() => _selectedMethod = p['id']!),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _selectedMethod == p['id'] ? AppColors.primaryOrange : Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: p['color']!.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(p['icon']!, color: p['color']!, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        p['name']!,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (_selectedMethod == p['id'])
                      const Icon(Icons.check_circle_rounded, color: AppColors.primaryOrange),
                  ],
                ),
              ),
            )),

            const SizedBox(height: 32),

            // ── Pay Button ────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryOrange, Color(0xFFEA580C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: _handlePayment,
                  child: Text(
                    _selectedTier == SubscriptionTier.premium
                        ? 'Bayar Premium Rp 79.000 via Midtrans'
                        : 'Bayar Reguler Rp 49.000 via Midtrans',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, Color color, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
