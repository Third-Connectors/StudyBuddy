import 'package:equatable/equatable.dart';

/// User roles in the Study Buddy platform.
enum UserRole { student, parent, teacher }

/// User model representing authenticated users.
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? profileImageUrl;
  final String? schoolName;
  final String? gradeLevel;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.student,
    this.profileImageUrl,
    this.schoolName,
    this.gradeLevel,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.student,
      ),
      profileImageUrl: json['profileImageUrl'] as String?,
      schoolName: json['schoolName'] as String?,
      gradeLevel: json['gradeLevel'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
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
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? profileImageUrl,
    String? schoolName,
    String? gradeLevel,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      schoolName: schoolName ?? this.schoolName,
      gradeLevel: gradeLevel ?? this.gradeLevel,
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
    createdAt,
    lastLoginAt,
  ];
}
