import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/leaderboard_entry_model.dart';

// ════════════════════════════════════════════════════════════
// 🔌 PLACEHOLDER — Ganti dengan API call nyata
// Endpoint : GET /leaderboard?period=weekly
// Response : [{"rank":1,"name":"...","xp":2500,...}]
// TODO: Implementasi setelah backend tersedia.
// ════════════════════════════════════════════════════════════

final selectedPeriodProvider = StateProvider<LeaderboardPeriod>(
  (ref) => LeaderboardPeriod.weekly,
);

final leaderboardProvider =
    Provider.family<List<LeaderboardEntry>, LeaderboardPeriod>((ref, period) {
      if (period == LeaderboardPeriod.weekly) {
        return const [
          LeaderboardEntry(
            rank: 1,
            name: 'Andi Pratama',
            xpPoints: 2500,
            gradeClass: 'Kelas 12 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 2,
            name: 'Siti Rahayu',
            xpPoints: 2350,
            gradeClass: 'Kelas 12 IPS',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 3,
            name: 'Budi Santoso',
            xpPoints: 2100,
            gradeClass: 'Kelas 11 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 4,
            name: 'Citra Dewi',
            xpPoints: 1950,
            gradeClass: 'Kelas 12 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 5,
            name: 'Deni Firmansyah',
            xpPoints: 1820,
            gradeClass: 'Kelas 11 IPS',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 6,
            name: 'Eka Putri',
            xpPoints: 1740,
            gradeClass: 'Kelas 12 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 7,
            name: 'Fajar Nugroho',
            xpPoints: 1680,
            gradeClass: 'Kelas 10 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 8,
            name: 'Benjamin Šeško',
            xpPoints: 1250,
            gradeClass: 'Class 12',
            isCurrentUser: true,
          ),
          LeaderboardEntry(
            rank: 9,
            name: 'Gilang Ramadhan',
            xpPoints: 1180,
            gradeClass: 'Kelas 11 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 10,
            name: 'Hana Kusuma',
            xpPoints: 1120,
            gradeClass: 'Kelas 12 IPS',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 11,
            name: 'Irfan Hakim',
            xpPoints: 1050,
            gradeClass: 'Kelas 10 IPS',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 12,
            name: 'Julia Sari',
            xpPoints: 980,
            gradeClass: 'Kelas 11 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 13,
            name: 'Kevin Andhika',
            xpPoints: 920,
            gradeClass: 'Kelas 12 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 14,
            name: 'Laila Nuraini',
            xpPoints: 870,
            gradeClass: 'Kelas 10 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 15,
            name: 'Miko Santana',
            xpPoints: 810,
            gradeClass: 'Kelas 11 IPS',
            isCurrentUser: false,
          ),
        ];
      } else {
        // All-time: same names, higher XP (roughly 3–4× weekly, randomized)
        return const [
          LeaderboardEntry(
            rank: 1,
            name: 'Andi Pratama',
            xpPoints: 9200,
            gradeClass: 'Kelas 12 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 2,
            name: 'Siti Rahayu',
            xpPoints: 8750,
            gradeClass: 'Kelas 12 IPS',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 3,
            name: 'Budi Santoso',
            xpPoints: 7980,
            gradeClass: 'Kelas 11 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 4,
            name: 'Citra Dewi',
            xpPoints: 7410,
            gradeClass: 'Kelas 12 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 5,
            name: 'Deni Firmansyah',
            xpPoints: 6850,
            gradeClass: 'Kelas 11 IPS',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 6,
            name: 'Eka Putri',
            xpPoints: 6340,
            gradeClass: 'Kelas 12 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 7,
            name: 'Fajar Nugroho',
            xpPoints: 5920,
            gradeClass: 'Kelas 10 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 8,
            name: 'Benjamin Šeško',
            xpPoints: 4380,
            gradeClass: 'Class 12',
            isCurrentUser: true,
          ),
          LeaderboardEntry(
            rank: 9,
            name: 'Gilang Ramadhan',
            xpPoints: 4110,
            gradeClass: 'Kelas 11 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 10,
            name: 'Hana Kusuma',
            xpPoints: 3890,
            gradeClass: 'Kelas 12 IPS',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 11,
            name: 'Irfan Hakim',
            xpPoints: 3540,
            gradeClass: 'Kelas 10 IPS',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 12,
            name: 'Julia Sari',
            xpPoints: 3280,
            gradeClass: 'Kelas 11 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 13,
            name: 'Kevin Andhika',
            xpPoints: 3010,
            gradeClass: 'Kelas 12 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 14,
            name: 'Laila Nuraini',
            xpPoints: 2760,
            gradeClass: 'Kelas 10 IPA',
            isCurrentUser: false,
          ),
          LeaderboardEntry(
            rank: 15,
            name: 'Miko Santana',
            xpPoints: 2490,
            gradeClass: 'Kelas 11 IPS',
            isCurrentUser: false,
          ),
        ];
      }
    });
