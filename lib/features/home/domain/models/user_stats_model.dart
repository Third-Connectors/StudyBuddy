import 'package:equatable/equatable.dart';

class UserStats extends Equatable {
  final int streak;
  final int xp;
  final int rank;
  final String presence;

  const UserStats({
    required this.streak,
    required this.xp,
    required this.rank,
    required this.presence,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      streak: (json['study_streak_days'] ?? 0) as int,
      xp: (json['xp'] ?? 0) as int,
      rank: (json['rank'] ?? 0) as int,
      presence: (json['presence'] ?? '0%').toString(),
    );
  }

  @override
  List<Object?> get props => [streak, xp, rank, presence];
}
