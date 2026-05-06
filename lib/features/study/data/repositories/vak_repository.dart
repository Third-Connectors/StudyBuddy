import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/vak_model.dart';
import '../../../../core/providers/supabase_provider.dart';

/// Repository for VAK (Visual, Auditory, Kinesthetic) assessment.
class VakRepository {
  final supabase.SupabaseClient _supabase;

  VakRepository(this._supabase);

  /// Get VAK assessment questions.
  ///
  /// For now, returns hardcoded questions.
  /// Future: Fetch from 'vak_questions' table in Supabase.
  Future<List<VakQuestion>> getQuestions() async {
    // Return hardcoded questions for reliability
    return _getHardcodedQuestions();
  }

  /// Submit VAK answers and save to Supabase.
  Future<VakResult> submitAnswers({
    required String userId,
    required List<VakAnswer> answers,
  }) async {
    try {
      // 1. Calculate result locally
      final result = _calculateResultLocally(userId, answers);

      // 2. Save to 'vak_results' table
      await _supabase.from('vak_results').insert({
        'user_id': userId,
        'visual_score': result.visualScore,
        'auditory_score': result.auditoryScore,
        'kinesthetic_score': result.kinestheticScore,
        'dominant_style': result.dominantStyle.name,
        'confidence_score': result.confidence,
        'answers': answers.map((a) => a.toJson()).toList(),
      });

      // 3. Update user profile with learning style
      await _supabase.from('profiles').update({
        'learning_style': result.dominantStyle.name,
      }).eq('id', userId);

      return result;
    } catch (e) {
      debugPrint('[VakRepository] Submit answers error: $e');
      throw Exception('Failed to save assessment: $e');
    }
  }

  /// Get user's latest VAK result from Supabase.
  Future<VakResult?> getUserResult(String userId) async {
    try {
      final response = await _supabase
          .from('vak_results')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;

      // Map Supabase snake_case to model camelCase
      return VakResult(
        userId: response['user_id'],
        dominantStyle: VakStyle.values.firstWhere(
          (e) => e.name == response['dominant_style'],
          orElse: () => VakStyle.visual,
        ),
        visualScore: (response['visual_score'] as num).toDouble(),
        auditoryScore: (response['auditory_score'] as num).toDouble(),
        kinesthetic_score: (response['kinesthetic_score'] as num).toDouble(),
        confidence: (response['confidence_score'] as num?)?.toDouble() ?? 0.0,
        completedAt: DateTime.parse(response['completed_at']),
        answers: (response['answers'] as List)
            .map((e) => VakAnswer.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      debugPrint('[VakRepository] Get result error: $e');
      return null;
    }
  }

  /// Check if user can recalibrate (once per semester).
  Future<bool> canRecalibrate(String userId) async {
    try {
      final result = await getUserResult(userId);
      if (result == null) return true;

      // Allow if last assessment was > 4 months ago
      final monthsSince =
          DateTime.now().difference(result.completedAt).inDays ~/ 30;
      return monthsSince >= 4;
    } catch (e) {
      return true;
    }
  }

  /// Save VAK result to local storage (for offline use).
  ///
  /// TODO: Implement with Hive/SharedPreferences.
  Future<void> saveResultLocally(VakResult result) async {
    // TODO: Save to Hive
    debugPrint(
      '[VakRepository] Saving result locally: ${result.dominantStyle}',
    );
  }

  /// Get last VAK result from local storage.
  ///
  /// TODO: Implement with Hive/SharedPreferences.
  Future<VakResult?> getLocalResult(String userId) async {
    // TODO: Load from Hive
    return null;
  }

  /// Calculate VAK result locally using KNN-like scoring.
  ///
  /// This is a simplified KNN approach:
  /// 1. Count responses for each style (A=Visual, B=Auditory, C=Kinesthetic)
  /// 2. Normalize scores to 0-1 range
  /// 3. Determine dominant style
  VakResult _calculateResultLocally(String userId, List<VakAnswer> answers) {
    double visualScore = 0;
    double auditoryScore = 0;
    double kinestheticScore = 0;

    // Count scores (KNN-like feature counting)
    for (final answer in answers) {
      switch (answer.selectedOption.toUpperCase()) {
        case 'A':
          visualScore++;
          break;
        case 'B':
          auditoryScore++;
          break;
        case 'C':
          kinestheticScore++;
          break;
      }
    }

    // Normalize scores (0-1 range)
    final total = answers.length.toDouble();
    visualScore = visualScore / total;
    auditoryScore = auditoryScore / total;
    kinestheticScore = kinestheticScore / total;

    // Determine dominant style
    final scores = {
      VakStyle.visual: visualScore,
      VakStyle.auditory: auditoryScore,
      VakStyle.kinesthetic: kinestheticScore,
    };

    final dominantStyle = scores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Calculate confidence (how dominant is the dominant style?)
    final maxScore = scores[dominantStyle]!;
    final avgScore = (visualScore + auditoryScore + kinestheticScore) / 3;
    final confidence = ((maxScore - avgScore) * 3).clamp(0.0, 1.0);

    return VakResult(
      userId: userId,
      dominantStyle: dominantStyle,
      visualScore: visualScore,
      auditoryScore: auditoryScore,
      kinestheticScore: kinestheticScore,
      completedAt: DateTime.now(),
      answers: answers,
      confidence: confidence,
    );
  }

  /// Check local eligibility for recalibration.
  ///
  /// Allows recalibration if:
  /// - No previous result exists
  /// - Last assessment was > 4 months ago (semester)
  Future<bool> _checkLocalRecalibrationEligibility(String userId) async {
    final localResult = await getLocalResult(userId);

    if (localResult == null) {
      return true; // No previous result, allow
    }

    // Check if > 4 months ago (one semester)
    final monthsSince =
        DateTime.now().difference(localResult.completedAt).inDays ~/ 30;
    return monthsSince >= 4;
  }

  /// Hardcoded VAK questions (20 psychometric survey questions).
  ///
  /// These questions are designed to identify learning style preferences
  /// for Indonesian high school students (SMA/MA/SMK).
  List<VakQuestion> _getHardcodedQuestions() {
    return [
      const VakQuestion(
        id: 1,
        question: 'Ketika mempelajari sesuatu yang baru, aku lebih suka...',
        optionA: 'Melihat gambar, diagram, atau video',
        optionB: 'Mendengarkan penjelasan dari guru/teman',
        optionC: 'Langsung mencoba/praktik sendiri',
      ),
      const VakQuestion(
        id: 2,
        question: 'Saat aku harus mengikuti petunjuk, aku lebih suka...',
        optionA: 'Membaca petunjuk tertulis',
        optionB: 'Mendengarkan penjelasan lisan',
        optionC: 'Langsung mencoba sambil belajar',
      ),
      const VakQuestion(
        id: 3,
        question: 'Ketika aku punya waktu luang, aku biasanya...',
        optionA: 'Menonton video atau membaca buku bergambar',
        optionB: 'Mendengarkan musik atau podcast',
        optionC: 'Berolahraga atau melakukan aktivitas fisik',
      ),
      const VakQuestion(
        id: 4,
        question: 'Aku paling mudah mengingat...',
        optionA: 'Apa yang aku lihat',
        optionB: 'Apa yang aku dengar',
        optionC: 'Apa yang aku lakukan',
      ),
      const VakQuestion(
        id: 5,
        question: 'Ketika belajar untuk ujian, aku lebih suka...',
        optionA: 'Membuat catatan berwarna dan mind map',
        optionB: 'Diskusi dengan teman atau membaca keras-keras',
        optionC: 'Mengerjakan latihan soal berulang-ulang',
      ),
      const VakQuestion(
        id: 6,
        question: 'Di kelas, aku lebih suka guru yang...',
        optionA: 'Menggunakan banyak gambar dan slide presentasi',
        optionB: 'Menjelaskan dengan detail dan jelas',
        optionC: 'Memberikan banyak praktik dan eksperimen',
      ),
      const VakQuestion(
        id: 7,
        question: 'Ketika aku tersesat di tempat baru, aku...',
        optionA: 'Melihat peta atau tanda-tanda visual',
        optionB: 'Bertanya pada orang sekitar',
        optionC: 'Coba jalan terus sampai menemukan jalan',
      ),
      const VakQuestion(
        id: 8,
        question: 'Aku paling suka tugas yang...',
        optionA: 'Banyak gambar dan ilustrasi',
        optionB: 'Ada diskusi presentasi',
        optionC: 'Ada praktik atau eksperimen',
      ),
      const VakQuestion(
        id: 9,
        question: 'Ketika membeli barang baru, aku...',
        optionA: 'Melihat gambar dan spesifikasi',
        optionB: 'Mendengarkan review dari orang lain',
        optionC: 'Langsung mencoba barangnya',
      ),
      const VakQuestion(
        id: 10,
        question: 'Aku lebih suka pelajaran yang...',
        optionA: 'Banyak diagram dan gambar (seperti Biologi)',
        optionB: 'Banyak diskusi dan cerita (seperti Sejarah)',
        optionC: 'Banyak praktikum (seperti Kimia/Fisika)',
      ),
      const VakQuestion(
        id: 11,
        question: 'Ketika menjelaskan sesuatu, aku sering...',
        optionA: 'Menggambar atau menunjukkan',
        optionB: 'Menjelaskan dengan kata-kata',
        optionC: 'Mendemonstrasikan langsung',
      ),
      const VakQuestion(
        id: 12,
        question: 'Aku terganggu ketika...',
        optionA: 'Tempat berantakan atau tidak rapi',
        optionB: 'Ada suara bising',
        optionC: 'Harus duduk diam terlalu lama',
      ),
      const VakQuestion(
        id: 13,
        question: 'Ketika belajar bahasa baru, aku lebih suka...',
        optionA: 'Melihat tulisan dan gambar',
        optionB: 'Mendengarkan dan mengulang',
        optionC: 'Praktik langsung berbicara',
      ),
      const VakQuestion(
        id: 14,
        question: 'Aku lebih mudah paham dengan...',
        optionA: 'Video tutorial',
        optionB: 'Podcast atau rekaman suara',
        optionC: 'Tutorial praktik langsung',
      ),
      const VakQuestion(
        id: 15,
        question: 'Ketika bermain game, aku lebih suka...',
        optionA: 'Game dengan grafis bagus',
        optionB: 'Game dengan cerita menarik',
        optionC: 'Game yang butuh keterampilan fisik',
      ),
      const VakQuestion(
        id: 16,
        question: 'Ruangan belajarku biasanya...',
        optionA: 'Banyak poster dan catatan di dinding',
        optionB: 'Sering diputar musik atau audio',
        optionC: 'Banyak alat praktik atau benda untuk disentuh',
      ),
      const VakQuestion(
        id: 17,
        question: 'Ketika menghadapi masalah, aku...',
        optionA: 'Membuat daftar atau diagram',
        optionB: 'Curhat atau diskusi dengan orang lain',
        optionC: 'Langsung action mencari solusi',
      ),
      const VakQuestion(
        id: 18,
        question: 'Aku lebih suka presentasi yang...',
        optionA: 'Banyak slide dan visual',
        optionB: 'Penjelasan detail dari presenter',
        optionC: 'Ada demo atau praktik langsung',
      ),
      const VakQuestion(
        id: 19,
        question: 'Ketika menghafal, aku biasanya...',
        optionA: 'Menulis ulang atau membuat catatan visual',
        optionB: 'Membaca keras-keras atau mendengarkan',
        optionC: 'Sambil bergerak atau melakukan sesuatu',
      ),
      const VakQuestion(
        id: 20,
        question: 'Teman-temanku bilang aku...',
        optionA: 'Peka terhadap tampilan dan warna',
        optionB: 'Pendengar yang baik',
        optionC: 'Aktif dan suka bergerak',
      ),
    ];
  }
}

/// Provider for the VAK repository.
final vakRepositoryProvider = Provider<VakRepository>((ref) {
  return VakRepository(ref.watch(supabaseClientProvider));
});
