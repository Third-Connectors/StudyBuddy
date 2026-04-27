import 'package:equatable/equatable.dart';

/// User roles in the Study Buddy platform.
enum UserRole { student, parent, teacher }

/// User model representing authenticated users with full profile data.
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? profileImageUrl;
  final String? schoolName;
  final String? gradeLevel;
  final int xpPoints;
  final int rank;
  final int presencePercentage;
  final String targetUniversity;
  final int fireStreak;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.student,
    this.profileImageUrl,
    this.schoolName,
    this.gradeLevel,
    this.xpPoints = 0,
    this.rank = 1,
    this.presencePercentage = 0,
    this.targetUniversity = 'Universitas Indonesia',
    this.fireStreak = 0,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      name: (json['name'] ?? json['full_name'] ?? 'Student') as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == (json['role'] ?? 'student'),
        orElse: () => UserRole.student,
      ),
      profileImageUrl: (json['profile_image_url'] ?? json['profileImageUrl']) as String?,
      schoolName: (json['school_name'] ?? json['schoolName']) as String?,
      gradeLevel: (json['grade_level'] ?? json['gradeLevel'] ?? '12') as String?,
      xpPoints: (json['xp_points'] ?? 0) as int,
      rank: (json['rank'] ?? 1) as int,
      presencePercentage: (json['presence_percentage'] ?? 0) as int,
      targetUniversity: (json['target_university'] ?? 'Universitas Indonesia') as String,
      fireStreak: (json['fire_streak'] ?? 0) as int,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      lastLoginAt: json['last_sign_in_at'] != null
          ? DateTime.tryParse(json['last_sign_in_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'profileImageUrl': profileImageUrl,
      'schoolName': schoolName,
      'gradeLevel': gradeLevel,
      'xp_points': xpPoints,
      'rank': rank,
      'presence_percentage': presencePercentage,
      'target_university': targetUniversity,
      'fire_streak': fireStreak,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? profileImageUrl,
    String? schoolName,
    String? gradeLevel,
    int? xpPoints,
    int? rank,
    int? presencePercentage,
    String? targetUniversity,
    int? fireStreak,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      schoolName: schoolName ?? this.schoolName,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      xpPoints: xpPoints ?? this.xpPoints,
      rank: rank ?? this.rank,
      presencePercentage: presencePercentage ?? this.presencePercentage,
      targetUniversity: targetUniversity ?? this.targetUniversity,
      fireStreak: fireStreak ?? this.fireStreak,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    role,
    profileImageUrl,
    schoolName,
    gradeLevel,
    xpPoints,
    rank,
    presencePercentage,
    targetUniversity,
    fireStreak,
    createdAt,
    lastLoginAt,
  ];
}
