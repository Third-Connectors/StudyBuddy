import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/vak_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';

/// Repository for VAK (Visual, Auditory, Kinesthetic) assessment.
class VakRepository {
  final ApiClient _apiClient;

  VakRepository(this._apiClient);

  /// Get VAK assessment questions.
  ///
  /// ⚠️ TODO: Implement actual API call
  ///
  /// For now, returns 20 hardcoded psychometric questions.
  Future<List<VakQuestion>> getQuestions() async {
    // ⚠️ PLACEHOLDER - Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Return hardcoded questions for offline use
    return _getHardcodedQuestions();

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(ApiEndpoints.vakQuestions);
    return (response['questions'] as List)
        .map((q) => VakQuestion.fromJson(q))
        .toList();
    */
  }

  /// Submit VAK answers and get result.
  ///
  /// ⚠️ TODO: Implement actual API call
  ///
  /// For now, calculates result locally using KNN-like scoring.
  Future<VakResult> submitAnswers(
    String userId,
    List<VakAnswer> answers,
  ) async {
    // ⚠️ PLACEHOLDER - Calculate result locally
    await Future.delayed(const Duration(seconds: 1));

    // Calculate scores using simple counting (KNN-like approach)
    double visualScore = 0;
    double auditoryScore = 0;
    double kinestheticScore = 0;

    for (final answer in answers) {
      switch (answer.selectedOption) {
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
    final total = answers.length;
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

    final result = VakResult(
      userId: userId,
      dominantStyle: dominantStyle,
      visualScore: visualScore,
      auditoryScore: auditoryScore,
      kinestheticScore: kinestheticScore,
      completedAt: DateTime.now(),
      answers: answers,
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.post(
      ApiEndpoints.vakSubmit,
      {
        'userId': userId,
        'answers': answers.map((a) => a.toJson()).toList(),
      },
    );
    return VakResult.fromJson(response['result']);
    */

    return result;
  }

  /// Get user's VAK result.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<VakResult?> getUserResult(String userId) async {
    // ⚠️ PLACEHOLDER - Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Return null (no result yet)
    return null;

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      '${ApiEndpoints.vakResult}?userId=$userId',
    );
    return VakResult.fromJson(response['result']);
    */
  }

  /// Recalibrate VAK assessment (user can retake once per semester).
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<bool> canRecalibrate(String userId) async {
    // ⚠️ PLACEHOLDER - Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 300));

    // For now, always allow recalibration
    return true;

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      '${ApiEndpoints.vakResult}/can-recalibrate?userId=$userId',
    );
    return response['canRecalibrate'] as bool;
    */
  }

  /// Hardcoded VAK questions (20 psychometric survey questions).
  ///
  /// These questions are designed to identify learning style preferences
  /// for Indonesian high school students.
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
        question: 'Aku lebih suka tugas yang...',
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
        question: 'Aku paling suka pelajaran yang...',
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
  return VakRepository(ref.watch(apiClientProvider));
});
