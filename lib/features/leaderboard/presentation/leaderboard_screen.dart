import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Leaderboard Screen - Display user rankings.
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Harian'),
            Tab(text: 'Mingguan'),
            Tab(text: 'Bulanan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboard('daily'),
          _buildLeaderboard('weekly'),
          _buildLeaderboard('monthly'),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(String timeframe) {
    // Mock data - TODO: Replace with actual data from repository
    final mockEntries = List.generate(
      50,
      (index) => {
        'rank': index + 1,
        'name': 'User ${index + 1}',
        'school': 'SMA Negeri ${index + 1}',
        'xp': 10000 - (index * 100),
        'level': 10 - (index ~/ 5),
      },
    );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockEntries.length,
      itemBuilder: (context, index) {
        final entry = mockEntries[index];
        final rank = entry['rank'] as int;
        final isTop3 = rank <= 3;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: SizedBox(
              width: 40,
              child: Center(
                child: rank <= 3
                    ? Text(
                        rank == 1
                            ? '🥇'
                            : rank == 2
                            ? '🥈'
                            : '🥉',
                        style: const TextStyle(fontSize: 24),
                      )
                    : Text(
                        '#$rank',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              entry['name'] as String,
              style: TextStyle(
                fontWeight: isTop3 ? FontWeight.bold : FontWeight.normal,
                color: isTop3 ? Colors.amber[800] : null,
              ),
            ),
            subtitle: Text(entry['school'] as String),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry['xp']} XP',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  'Level ${entry['level']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
