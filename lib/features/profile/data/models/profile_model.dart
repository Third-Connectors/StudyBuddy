import 'package:equatable/equatable.dart';

/// Leaderboard entry model.
class LeaderboardEntry extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? profileImageUrl;
  final String? schoolName;
  final int rank;
  final int xp;
  final int level;
  final int badges;
  final DateTime? lastActiveAt;

  const LeaderboardEntry({
    required this.id,
    required this.userId,
    required this.userName,
    this.profileImageUrl,
    this.schoolName,
    required this.rank,
    required this.xp,
    required this.level,
    required this.badges,
    this.lastActiveAt,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      schoolName: json['schoolName'] as String?,
      rank: json['rank'] as int,
      xp: json['xp'] as int,
      level: json['level'] as int,
      badges: json['badges'] as int,
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'profileImageUrl': profileImageUrl,
      'schoolName': schoolName,
      'rank': rank,
      'xp': xp,
      'level': level,
      'badges': badges,
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  LeaderboardEntry copyWith({
    String? id,
    String? userId,
    String? userName,
    String? profileImageUrl,
    String? schoolName,
    int? rank,
    int? xp,
    int? level,
    int? badges,
    DateTime? lastActiveAt,
  }) {
    return LeaderboardEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      schoolName: schoolName ?? this.schoolName,
      rank: rank ?? this.rank,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    profileImageUrl,
    schoolName,
    rank,
    xp,
    level,
    badges,
    lastActiveAt,
  ];
}

/// User profile with extended stats.
class UserProfile extends Equatable {
  final String userId;
  final String name;
  final String email;
  final String? schoolName;
  final String? gradeLevel;
  final int xp;
  final int level;
  final int badges;
  final int quizzesCompleted;
  final int averageScore;
  final String? learningStyle;
  final DateTime joinedAt;
  final DateTime? lastActiveAt;

  const UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    this.schoolName,
    this.gradeLevel,
    required this.xp,
    required this.level,
    required this.badges,
    required this.quizzesCompleted,
    required this.averageScore,
    this.learningStyle,
    required this.joinedAt,
    this.lastActiveAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      schoolName: json['schoolName'] as String?,
      gradeLevel: json['gradeLevel'] as String?,
      xp: json['xp'] as int,
      level: json['level'] as int,
      badges: json['badges'] as int,
      quizzesCompleted: json['quizzesCompleted'] as int,
      averageScore: json['averageScore'] as int,
      learningStyle: json['learningStyle'] as String?,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'schoolName': schoolName,
      'gradeLevel': gradeLevel,
      'xp': xp,
      'level': level,
      'badges': badges,
      'quizzesCompleted': quizzesCompleted,
      'averageScore': averageScore,
      'learningStyle': learningStyle,
      'joinedAt': joinedAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? userId,
    String? name,
    String? email,
    String? schoolName,
    String? gradeLevel,
    int? xp,
    int? level,
    int? badges,
    int? quizzesCompleted,
    int? averageScore,
    String? learningStyle,
    DateTime? joinedAt,
    DateTime? lastActiveAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      schoolName: schoolName ?? this.schoolName,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      averageScore: averageScore ?? this.averageScore,
      learningStyle: learningStyle ?? this.learningStyle,
      joinedAt: joinedAt ?? this.joinedAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    schoolName,
    gradeLevel,
    xp,
    level,
    badges,
    quizzesCompleted,
    averageScore,
    learningStyle,
    joinedAt,
    lastActiveAt,
  ];
}
