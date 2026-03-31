import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/schedule_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';

/// Repository for Schedule Scanner (OCR + Genetic Algorithm).
class ScheduleRepository {
  final ApiClient _apiClient;
  final ImagePicker _imagePicker;

  ScheduleRepository(this._apiClient) : _imagePicker = ImagePicker();

  /// Pick an image from gallery.
  Future<XFile?> pickImageFromGallery() async {
    return await _imagePicker.pickImage(source: ImageSource.gallery);
  }

  /// Take a photo with camera.
  Future<XFile?> takePhoto() async {
    return await _imagePicker.pickImage(source: ImageSource.camera);
  }

  /// Upload schedule image for OCR processing.
  ///
  /// ⚠️ TODO: Implement actual API call
  ///
  /// Flow:
  /// 1. Upload image to backend
  /// 2. Backend processes with Google Cloud Vision OCR + Gemini Vision
  /// 3. Extract schedule data (subject, time, location, etc.)
  /// 4. Return structured schedule entries
  Future<OcrResult> uploadScheduleImage(String imagePath) async {
    // ⚠️ PLACEHOLDER - Simulate OCR processing
    await Future.delayed(const Duration(seconds: 2));

    // Mock OCR result
    return OcrResult(
      rawText: '''
JADWAL PELAJARAN KELAS 11 IPA 1
SENIN: 07:00-08:30 Matematika, 08:30-10:00 Fisika, 10:30-12:00 Bahasa Indonesia
SELASA: 07:00-09:00 Biologi, 09:30-11:00 Kimia, 13:00-14:30 Olahraga
RABU: 07:00-08:30 Bahasa Inggris, 08:30-10:00 Sejarah, 10:30-12:00 Ekonomi
KAMIS: 07:00-09:00 Matematika, 09:30-11:00 Fisika
JUMAT: 07:00-09:00 Agama, 09:30-11:00 PKN
      ''',
      extractedSchedules: [
        ScheduleEntry(
          id: 'sch_1',
          userId: 'user_123',
          subject: 'Matematika',
          subjectCode: 'MTK',
          startTime: DateTime(2024, 1, 1, 7, 0),
          endTime: DateTime(2024, 1, 1, 8, 30),
          location: 'Ruang 101',
          isRecurring: true,
          recurringDays: ['MON'],
          createdAt: DateTime.now(),
        ),
        ScheduleEntry(
          id: 'sch_2',
          userId: 'user_123',
          subject: 'Fisika',
          subjectCode: 'FIS',
          startTime: DateTime(2024, 1, 1, 8, 30),
          endTime: DateTime(2024, 1, 1, 10, 0),
          location: 'Ruang 102',
          isRecurring: true,
          recurringDays: ['MON', 'THU'],
          createdAt: DateTime.now(),
        ),
      ],
      imageUrl: imagePath,
      scannedAt: DateTime.now(),
    );

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.uploadFile(
      ApiEndpoints.scannerUpload,
      imagePath,
    );
    return OcrResult.fromJson(response['result']);
    */
  }

  /// Process OCR result and extract schedule entries.
  ///
  /// ⚠️ TODO: Implement actual API call with Gemini Vision
  ///
  /// This method should:
  /// 1. Send image to Gemini Vision API
  /// 2. Use prompt to extract schedule information
  /// 3. Parse response into structured ScheduleEntry objects
  Future<OcrResult> processOcr(String imagePath) async {
    // ⚠️ PLACEHOLDER - Simulate processing
    return await uploadScheduleImage(imagePath);

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.post(
      ApiEndpoints.scannerOcr,
      {'imagePath': imagePath},
    );
    return OcrResult.fromJson(response['result']);
    */
  }

  /// Get all user schedules.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<List<ScheduleEntry>> getSchedules(String userId) async {
    // ⚠️ PLACEHOLDER - Return empty list
    await Future.delayed(const Duration(milliseconds: 500));

    return [];

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      '${ApiEndpoints.schedule}?userId=$userId',
    );
    return (response['schedules'] as List)
        .map((s) => ScheduleEntry.fromJson(s))
        .toList();
    */
  }

  /// Add a new schedule entry.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<ScheduleEntry> addSchedule(ScheduleEntry schedule) async {
    // ⚠️ PLACEHOLDER - Return the same schedule
    await Future.delayed(const Duration(milliseconds: 500));

    return schedule;

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.post(
      ApiEndpoints.schedule,
      schedule.toJson(),
    );
    return ScheduleEntry.fromJson(response['schedule']);
    */
  }

  /// Update an existing schedule entry.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<ScheduleEntry> updateSchedule(ScheduleEntry schedule) async {
    // ⚠️ PLACEHOLDER - Return the same schedule
    await Future.delayed(const Duration(milliseconds: 500));

    return schedule;

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.put(
      ApiEndpoints.scheduleDetail.replaceFirst('{scheduleId}', schedule.id),
      schedule.toJson(),
    );
    return ScheduleEntry.fromJson(response['schedule']);
    */
  }

  /// Delete a schedule entry.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<void> deleteSchedule(String scheduleId) async {
    // ⚠️ PLACEHOLDER - No-op
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Uncomment when backend is ready
    /*
    await _apiClient.delete(
      ApiEndpoints.scheduleDetail.replaceFirst('{scheduleId}', scheduleId),
    );
    */
  }

  /// Generate optimized study schedule using Genetic Algorithm.
  ///
  /// ⚠️ TODO: Implement actual API call
  ///
  /// This should:
  /// 1. Get user's school schedule
  /// 2. Get user's VAK learning style
  /// 3. Get upcoming exams/deadlines
  /// 4. Run genetic algorithm to optimize study times
  /// 5. Return optimized study schedule
  Future<List<ScheduleEntry>> generateOptimizedStudySchedule({
    required String userId,
    required List<ScheduleEntry> schoolSchedule,
    required List<String> difficultSubjects,
    required List<DateTime> upcomingExams,
  }) async {
    // ⚠️ PLACEHOLDER - Return empty list
    await Future.delayed(const Duration(seconds: 1));

    // Mock optimized schedule
    return [
      ScheduleEntry(
        id: 'study_1',
        userId: userId,
        subject: 'Matematika',
        subjectCode: 'MTK',
        startTime: DateTime(2024, 1, 1, 19, 0),
        endTime: DateTime(2024, 1, 1, 20, 30),
        location: 'Rumah',
        notes: 'Fokus pada aljabar dan geometri',
        isRecurring: true,
        recurringDays: ['MON', 'WED', 'FRI'],
        createdAt: DateTime.now(),
      ),
      ScheduleEntry(
        id: 'study_2',
        userId: userId,
        subject: 'Fisika',
        subjectCode: 'FIS',
        startTime: DateTime(2024, 1, 1, 20, 0),
        endTime: DateTime(2024, 1, 1, 21, 30),
        location: 'Rumah',
        notes: 'Latihan soal kinematika',
        isRecurring: true,
        recurringDays: ['TUE', 'THU'],
        createdAt: DateTime.now(),
      ),
    ];

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.post(
      '${ApiEndpoints.schedule}/generate-optimized',
      {
        'userId': userId,
        'schoolSchedule': schoolSchedule.map((s) => s.toJson()).toList(),
        'difficultSubjects': difficultSubjects,
        'upcomingExams': upcomingExams.map((e) => e.toIso8601String()).toList(),
      },
    );
    return (response['schedules'] as List)
        .map((s) => ScheduleEntry.fromJson(s))
        .toList();
    */
  }

  /// Get schedule by ID.
  ///
  /// ⚠️ TODO: Implement actual API call
  Future<ScheduleEntry?> getScheduleById(String scheduleId) async {
    // ⚠️ PLACEHOLDER - Return null
    await Future.delayed(const Duration(milliseconds: 500));

    return null;

    // TODO: Uncomment when backend is ready
    /*
    final response = await _apiClient.get(
      ApiEndpoints.scheduleDetail.replaceFirst('{scheduleId}', scheduleId),
    );
    return ScheduleEntry.fromJson(response['schedule']);
    */
  }
}

/// Provider for the schedule repository.
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository(ref.watch(apiClientProvider));
});
