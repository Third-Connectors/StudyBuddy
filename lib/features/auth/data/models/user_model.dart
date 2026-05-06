import 'package:equatable/equatable.dart';

/// User roles in the Study Buddy platform.
enum UserRole { student, parent, teacher }

/// User model representing authenticated users with full profile data from Supabase.
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? profileImageUrl;
  final String? schoolName;
  final String? gradeLevel;
  final int xp;
  final int level;
  final String? learningStyle;
  final int rank;
  final String targetUniversity;
  final int fireStreak;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.student,
    this.profileImageUrl,
    this.schoolName,
    this.gradeLevel,
    this.xp = 0,
    this.level = 1,
    this.learningStyle,
    this.rank = 1,
    this.targetUniversity = 'Universitas Indonesia',
    this.fireStreak = 0,
    required this.createdAt,
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
      profileImageUrl: json['profile_image_url'] as String?,
      schoolName: json['school_name'] as String?,
      gradeLevel: json['grade_level']?.toString() ?? '12',
      xp: (json['xp'] ?? 0) as int,
      level: (json['level'] ?? 1) as int,
      learningStyle: json['learning_style'] as String?,
      rank: (json['rank'] ?? 1) as int,
      targetUniversity: json['target_university'] ?? 'Universitas Indonesia',
      fireStreak: (json['fire_streak'] ?? 0) as int,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'profile_image_url': profileImageUrl,
      'school_name': schoolName,
      'grade_level': gradeLevel,
      'xp': xp,
      'level': level,
      'learning_style': learningStyle,
      'rank': rank,
      'target_university': targetUniversity,
      'fire_streak': fireStreak,
      'created_at': createdAt.toIso8601String(),
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
    int? xp,
    int? level,
    String? learningStyle,
    int? rank,
    String? targetUniversity,
    int? fireStreak,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      schoolName: schoolName ?? this.schoolName,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      learningStyle: learningStyle ?? this.learningStyle,
      rank: rank ?? this.rank,
      targetUniversity: targetUniversity ?? this.targetUniversity,
      fireStreak: fireStreak ?? this.fireStreak,
      createdAt: createdAt ?? this.createdAt,
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
    xp,
    level,
    learningStyle,
    rank,
    targetUniversity,
    fireStreak,
    createdAt,
  ];
}
