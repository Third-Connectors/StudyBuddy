import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../home/data/home_providers.dart';
import '../../home/domain/models/user_stats_model.dart';

/// Leaderboard Screen - League-based ranking (Duolingo style).
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    // Get current user stats to determine their league
    final userStatsAsync = ref.watch(userStatsProvider);

    return userStatsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (userStats) {
        final currentTier = _getTier(userStats.xp);
        
        return Container(
          color: AppColors.backgroundCream,
          child: Column(
            children: [
              // ── 1. League Header ──────────────────────────────────────────
              _buildLeagueHeader(currentTier),

              // ── 2. Ranking List ───────────────────────────────────────────
              Expanded(
                child: _buildRankingList(currentTier, userStats),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeagueHeader(_TierData tier) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: tier.color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // League Icon / Badge
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: tier.color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: tier.color.withOpacity(0.3), width: 2),
            ),
            child: Icon(tier.icon, size: 60, color: tier.color),
          ),
          const SizedBox(height: 16),
          // League Name
          Text(
            '${tier.name} League',
            style: GoogleFonts.nunito(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Bersainglah dengan siswa di liga yang sama!',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: AppColors.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingList(_TierData tier, UserStats currentUser) {
    // Determine XP range for this league
    int minXp = 0;
    int? maxXp;

    if (tier.name == 'Diamond') { minXp = 20000; }
    else if (tier.name == 'Ruby') { minXp = 15000; maxXp = 19999; }
    else if (tier.name == 'Emerald') { minXp = 10000; maxXp = 14999; }
    else if (tier.name == 'Sapphire') { minXp = 7000; maxXp = 9999; }
    else if (tier.name == 'Gold') { minXp = 4000; maxXp = 6999; }
    else if (tier.name == 'Silver') { minXp = 1500; maxXp = 3999; }
    else { minXp = 0; maxXp = 1499; }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _supabase
          .from('profiles')
          .stream(primaryKey: ['id'])
          .order('xp', ascending: false),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange));
        }

        // Filter users in the same league
        final allUsers = snapshot.data!;
        final leagueUsers = allUsers.where((u) {
          final xp = (u['xp'] as num?)?.toInt() ?? 0;
          return xp >= minXp && (maxXp == null || xp <= maxXp);
        }).toList();

        if (leagueUsers.isEmpty) {
          return Center(
            child: Text(
              'Belum ada pesaing di liga ini.',
              style: GoogleFonts.nunito(color: AppColors.textLight),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          itemCount: leagueUsers.length,
          itemBuilder: (context, index) {
            final user = leagueUsers[index];
            final isMe = user['id'] == _supabase.auth.currentUser?.id;
            final rank = index + 1;

            return _buildRankItem(rank, user, isMe, tier.color);
          },
        );
      },
    );
  }

  Widget _buildRankItem(int rank, Map<String, dynamic> data, bool isMe, Color tierColor) {
    final name = data['name'] as String? ?? data['full_name'] as String? ?? 'Student';
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'S';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? tierColor.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isMe ? tierColor.withOpacity(0.5) : AppColors.divider,
          width: isMe ? 2 : 1,
        ),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: 35,
            child: Text(
              rank.toString(),
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: rank <= 3 ? AppColors.primaryOrange : AppColors.textLight,
              ),
            ),
          ),
          // Avatar
          CircleAvatar(
            backgroundColor: tierColor.withOpacity(0.2),
            child: Text(
              initial,
              style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: tierColor),
            ),
          ),
          const SizedBox(width: 16),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: isMe ? FontWeight.w800 : FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (isMe)
                  Text(
                    'Peringkat Kamu',
                    style: GoogleFonts.nunito(fontSize: 12, color: tierColor, fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
          // XP
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${data['xp']} XP',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(Icons.bolt_rounded, size: 14, color: AppColors.primaryOrange),
            ],
          ),
        ],
      ),
    );
  }

  _TierData _getTier(int xp) {
    if (xp >= 20000) return const _TierData('Diamond', Color(0xFF0EA5E9), Icons.diamond_rounded);
    if (xp >= 15000) return const _TierData('Ruby', Colors.redAccent, Icons.diamond_rounded);
    if (xp >= 10000) return const _TierData('Emerald', Colors.green, Icons.workspace_premium_rounded);
    if (xp >= 7000) return const _TierData('Sapphire', Colors.blueAccent, Icons.workspace_premium_rounded);
    if (xp >= 4000) return const _TierData('Gold', Colors.amber, Icons.star_rounded);
    if (xp >= 1500) return const _TierData('Silver', Colors.grey, Icons.star_rounded);
    return const _TierData('Bronze', Colors.brown, Icons.star_rounded);
  }
}

class _TierData {
  final String name;
  final Color color;
  final IconData icon;

  const _TierData(this.name, this.color, this.icon);
}
