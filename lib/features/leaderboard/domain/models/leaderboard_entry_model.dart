/// Represents a single entry on the leaderboard.
class LeaderboardEntry {
  final int rank;
  final String name;
  final int xpPoints;
  final String gradeClass;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.xpPoints,
    required this.gradeClass,
    this.isCurrentUser = false,
  });

  /// Returns the initials of the name (first letter of each word, max 2).
  /// e.g. "Andi Pratama" → "AP", "Benjamin Šeško" → "BŠ"
  String get initials {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0][0].toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  /// Formats XP with comma thousands separator.
  /// e.g. 1250 → "1,250", 2500 → "2,500"
  String get formattedXp {
    final s = xpPoints.toString();
    final buffer = StringBuffer();
    final offset = s.length % 3;
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (i - offset) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

/// The time period filter for the leaderboard.
enum LeaderboardPeriod { weekly, allTime }
