import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../data/home_providers.dart';
import '../domain/models/user_stats_model.dart';
import 'package:studybuddy/features/auth/data/models/user_model.dart';
import '../domain/models/daily_mission_model.dart';
import '../domain/models/study_material_model.dart';
import '../../study/presentation/practice_screen.dart';

/// Home screen dashboard matching the design.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Timer _timer;
  late Duration _timeUntilUTBK;

  @override
  void initState() {
    super.initState();
    _calculateTimeUntilUTBK();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          _calculateTimeUntilUTBK();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTimeUntilUTBK() {
    final now = DateTime.now();
    var targetDate = DateTime(now.year, 4, 21);
    if (now.isAfter(targetDate)) {
      targetDate = DateTime(now.year + 1, 4, 21);
    }
    _timeUntilUTBK = targetDate.difference(now);
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(userStatsProvider);
    final userAsync = ref.watch(userProvider);
    final missionsAsync = ref.watch(dailyMissionsProvider);
    final materialsAsync = ref.watch(studyMaterialsProvider);

    final stats = statsAsync.value ?? const UserStats(streak: 0, xp: 0, rank: 0, presence: '0%');
    final user = userAsync.value ?? UserModel(
      id: '',
      email: '',
      name: 'Student',
      gradeLevel: '12',
      xp: 0,
      rank: 1,
      targetUniversity: 'Universitas Indonesia',
      fireStreak: 0,
      createdAt: DateTime.now(),
    );

    final greetingData = _getGreeting();
    
    final days = _timeUntilUTBK.inDays.toString();
    final hours = (_timeUntilUTBK.inHours % 24).toString();
    final minutes = (_timeUntilUTBK.inMinutes % 60).toString();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Greeting Header ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${greetingData['text']}',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user.name}! ${greetingData['emoji']}',
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrangeLighter,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Class ${user.gradeLevel}',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrangeLighter,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildStreakFire(stats.streak),
                      const SizedBox(width: 6),
                      Text(
                        '${stats.streak}',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _getStreakColor(stats.streak),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── 2. UTBK SNBT Card ───────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.track_changes_outlined, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'UTBK SNBT ${_timeUntilUTBK.inDays < 0 ? DateTime.now().year : DateTime.now().year + (DateTime.now().month > 4 || (DateTime.now().month == 4 && DateTime.now().day > 21) ? 1 : 0)}',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'SNBT Practice',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.white, size: 16),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeBox(days, 'Day'),
                      const SizedBox(width: 16),
                      _buildTimeBox(hours, 'Hour'),
                      const SizedBox(width: 16),
                      _buildTimeBox(minutes, 'Minute'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.school_outlined, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Target: ${user.targetUniversity}',
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── 3. Quick Stats ──────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.bolt_rounded,
                    iconColor: AppColors.statXpIcon,
                    iconBg: AppColors.statXpBg,
                    value: stats.xp.toString(),
                    label: 'XP Point',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.trending_up_rounded,
                    iconColor: AppColors.statRankIcon,
                    iconBg: AppColors.statRankBg,
                    value: 'Rank ${stats.rank}',
                    label: 'Ranking',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.star_rounded,
                    iconColor: AppColors.statPresenceIcon,
                    iconBg: AppColors.statPresenceBg,
                    value: stats.presence,
                    label: 'Presence',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── 4. Daily Missions ───────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Missions',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'See All',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            missionsAsync.when(
              data: (missions) => missions.isEmpty 
                  ? _buildEmptyState('No missions yet!')
                  : Column(
                      children: missions.map((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildQuizItem(
                          subject: m.title,
                          status: m.isCompleted ? 'Done' : 'To do',
                          statusColor: m.isCompleted ? AppColors.statusDoneText : AppColors.statusToDoText,
                          statusBg: m.isCompleted ? AppColors.statusDoneBg : const Color(0xFFF3F4F6),
                          iconBg: (m.subject == 'Biologi' ? Colors.green : Colors.blue).withValues(alpha: 0.12),
                          icon: m.subject == 'Biologi' ? Icons.eco_rounded : Icons.psychology_rounded,
                          iconColor: m.subject == 'Biologi' ? Colors.green : Colors.blue,
                          onTap: () {
                            debugPrint('[HomeScreen] Mission tapped: ${m.title}');
                            final title = m.title.toLowerCase();
                            if (title.contains('socratic') || title.contains('math')) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PracticeScreen(
                                    subject: 'Matematika',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      )).toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),

            const SizedBox(height: 32),

            // ── 5. Study Materials ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Study Materials',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            materialsAsync.when(
              data: (materials) => materials.isEmpty
                  ? _buildEmptyState('No materials shared yet!')
                  : Column(
                      children: materials.map((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildMaterialCard(m),
                      )).toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizItem({
    required String subject,
    required String status,
    required Color statusColor,
    required Color statusBg,
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusBg == AppColors.statusInProgressBg ? AppColors.primaryOrangeLight : AppColors.divider),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                subject,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialCard(StudyMaterial m) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail Image with Hero-like feel
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryOrangeLighter,
              ),
              child: Image.network(
                m.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.description_outlined,
                  color: AppColors.primaryOrange,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrangeLighter,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    m.category.toUpperCase(),
                    style: GoogleFonts.nunito(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryOrange,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  m.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  m.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppColors.divider, size: 14),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, color: Colors.blueGrey.shade300, size: 40),
          const SizedBox(height: 12),
          Text(
            message,
            style: GoogleFonts.nunito(
              color: Colors.blueGrey.shade400,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakFire(int streak) {
    List<Color> gradientColors;
    if (streak < 7) {
      gradientColors = [Colors.red, Colors.orange];
    } else if (streak < 14) {
      gradientColors = [Colors.orange, Colors.yellow];
    } else if (streak < 30) {
      gradientColors = [Colors.yellow, Colors.white];
    } else if (streak < 60) {
      gradientColors = [Colors.cyanAccent, Colors.blueAccent];
    } else {
      gradientColors = [Colors.blueAccent, Colors.purpleAccent];
    }

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: gradientColors,
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(bounds),
      child: const Icon(
        Icons.whatshot_rounded,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  Color _getStreakColor(int streak) {
    if (streak < 7) return Colors.red;
    if (streak < 14) return Colors.orange;
    if (streak < 30) return const Color(0xFFF59E0B);
    if (streak < 60) return Colors.blueAccent;
    return Colors.purpleAccent;
  }

  Map<String, String> _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return {'text': 'Good Morning', 'emoji': '👋'};
    } else if (hour >= 12 && hour < 17) {
      return {'text': 'Good Afternoon', 'emoji': '☀️'};
    } else if (hour >= 17 && hour < 21) {
      return {'text': 'Good Evening', 'emoji': '🌆'};
    } else {
      return {'text': "It's time to sleep", 'emoji': '🌙'};
    }
  }
}
