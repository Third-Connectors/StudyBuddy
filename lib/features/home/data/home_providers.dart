import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/supabase_provider.dart';
import '../domain/models/user_stats_model.dart';
import 'package:studybuddy/features/auth/data/models/user_model.dart';
import '../domain/models/countdown_model.dart';
import '../domain/models/daily_mission_model.dart';
import '../domain/models/study_material_model.dart';

/// Provides the user stats from Supabase.
final userStatsProvider = StreamProvider<UserStats>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final user = supabase.auth.currentUser;

  if (user == null) {
    return Stream.value(const UserStats(streak: 0, xp: 0, rank: 0, presence: '0%'));
  }

  return supabase
      .from('user_stats')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id)
      .map((data) {
        if (data.isEmpty) {
          return const UserStats(streak: 0, xp: 0, rank: 0, presence: '0%');
        }
        return UserStats.fromJson(data.first);
      });
});

/// Provides basic user profile info from the profiles table.
final userProvider = StreamProvider<UserModel>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final user = supabase.auth.currentUser;

  if (user == null) {
    return Stream.value(UserModel(
      id: '',
      email: '',
      name: 'Student',
      gradeLevel: '12',
      xp: 0,
      rank: 1,
      targetUniversity: 'Universitas Indonesia',
      fireStreak: 0,
      createdAt: DateTime.now(),
    ));
  }

  return supabase
      .from('profiles')
      .stream(primaryKey: ['id'])
      .eq('id', user.id)
      .map((data) {
        if (data.isEmpty) {
          return UserModel(
            id: user.id,
            email: user.email ?? '',
            name: user.userMetadata?['name'] ?? 'Student',
            gradeLevel: '12',
            xp: 0,
            rank: 1,
            targetUniversity: 'Universitas Indonesia',
            fireStreak: 0,
            createdAt: DateTime.now(),
          );
        }
        return UserModel.fromJson(data.first);
      });
});

/// Provides daily missions from Supabase.
final dailyMissionsProvider = StreamProvider<List<DailyMission>>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final user = supabase.auth.currentUser;

  if (user == null) return Stream.value([]);

  return supabase
      .from('daily_missions')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id)
      .map((data) => data.map((json) => DailyMission.fromJson(json)).toList());
});

/// Provides study materials from Supabase.
final studyMaterialsProvider = StreamProvider<List<StudyMaterial>>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  
  return supabase
      .from('study_materials')
      .stream(primaryKey: ['id'])
      .map((data) => data.map((json) => StudyMaterial.fromJson(json)).toList())
      .handleError((error) {
        print('Error loading study materials: $error');
        return <StudyMaterial>[];
      });
});

/// Provides a simple countdown to UTBK 2026.
final countdownProvider = StateProvider<Countdown>((ref) {
  // Target date: May 1, 2026
  final targetDate = DateTime(2026, 5, 1);
  
  // Initial calculation
  final now = DateTime.now();
  final difference = targetDate.isAfter(now) 
      ? targetDate.difference(now) 
      : Duration.zero;

  return Countdown(
    days: difference.inDays,
    hours: difference.inHours % 24,
    minutes: difference.inMinutes % 60,
    seconds: difference.inSeconds % 60,
  );
});
