/// Represents the authenticated user's complete profile data.
class UserModel {
  final String id;
  final String name;
  final String gradeClass;
  final int xpPoints;
  final int rank;
  final int presencePercentage;
  final String targetUniversity;
  final int fireStreak;

  const UserModel({
    required this.id,
    required this.name,
    required this.gradeClass,
    required this.xpPoints,
    required this.rank,
    required this.presencePercentage,
    required this.targetUniversity,
    required this.fireStreak,
  });
}
