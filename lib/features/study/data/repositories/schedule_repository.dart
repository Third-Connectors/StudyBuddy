// ════════════════════════════════════════════════════════════════════════════
// 📅 SCHEDULE REPOSITORY — Gemini Vision OCR + Genetic Algorithm
// ════════════════════════════════════════════════════════════════════════════
//
// Smart Schedule Scanner for Indonesian High Schools.
//
// Features:
// - OCR using Gemini Vision API (handwritten & printed schedules)
// - Schedule parsing for Indonesian school format
// - Genetic Algorithm for optimized study scheduling
// - Integration with VAK learning styles
//
// Flow:
// 1. User uploads photo → Gemini Vision OCR → Parse schedule
// 2. Extract subjects, times, locations
// 3. Generate optimized study schedule using Genetic Algorithm
// ════════════════════════════════════════════════════════════════════════════

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/schedule_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/providers/api_providers.dart';

/// Repository for Schedule Scanner.
///
/// Handles:
/// - Image capture/picking
/// - OCR processing with Gemini Vision
/// - Schedule parsing
/// - Optimized study schedule generation
class ScheduleRepository {
  final ApiClient _apiClient;
  final ApiClient _geminiClient;
  final ImagePicker _imagePicker;

  ScheduleRepository(this._apiClient, this._geminiClient)
    : _imagePicker = ImagePicker();

  /// Pick an image from gallery.
  Future<XFile?> pickImageFromGallery() async {
    return await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
    );
  }

  /// Take a photo with camera.
  Future<XFile?> takePhoto() async {
    return await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 2048,
      maxHeight: 2048,
    );
  }

  /// Upload schedule image for OCR processing.
  ///
  /// Uses Gemini Vision API to extract text from schedule images.
  Future<OcrResult> uploadScheduleImage(String imagePath) async {
    try {
      // Read and encode image
      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);
      final mimeType = _getMimeType(imagePath);

      // OCR prompt for Indonesian school schedules
      final ocrPrompt = '''
Anda adalah sistem OCR khusus untuk jadwal pelajaran sekolah Indonesia (SMA/MA/SMK).

Tugas Anda:
1. Baca dan ekstrak semua informasi dari gambar jadwal ini
2. Identifikasi: Hari, Mata Pelajaran, Waktu Mulai, Waktu Selesai, Ruang (jika ada)
3. Format hasil dalam struktur JSON yang rapi

Format Output JSON:
{
  "rawText": "teks lengkap yang terbaca dari gambar",
  "schedules": [
    {
      "day": "SENIN",
      "subject": "Matematika",
      "startTime": "07:00",
      "endTime": "08:30",
      "location": "Ruang 101"
    }
  ]
}

Catatan:
- Gunakan format waktu 24 jam (HH:MM)
- Hari dalam bahasa Indonesia (SENIN, SELASA, RABU, KAMIS, JUMAT, SABTU)
- Jika ada tulisan tangan, coba interpretasikan sebaik mungkin
- Abaikan noise atau tulisan yang tidak jelas
''';

      // Call Gemini Vision API
      final response = await _geminiClient.post(
        '/models/${ApiConfig.geminiVisionModel}:generateContent',
        {
          'contents': [
            {
              'parts': [
                {'text': ocrPrompt},
                {
                  'inline_data': {'mime_type': mimeType, 'data': base64Image},
                },
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.3, // Lower temperature for accuracy
            'maxOutputTokens': 2048,
          },
        },
        queryParameters: {'key': ApiConfig.geminiApiKey},
      );

      // Extract and parse response
      final rawText = _extractGeminiResponse(response);
      final parsedSchedules = _parseScheduleFromOCR(rawText);

      return OcrResult(
        rawText: rawText,
        extractedSchedules: parsedSchedules,
        imageUrl: imagePath,
        scannedAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('[ScheduleRepository] OCR error: $e');
      throw Exception('Failed to process image: $e');
    }
  }

  /// Process OCR result and extract schedule entries.
  ///
  /// Alternative method that calls backend API (for production).
  Future<OcrResult> processOcr(String imagePath) async {
    // For production: Call backend API
    // Backend will handle OCR + parsing with better error handling
    try {
      final response = await _apiClient.uploadFile(
        ApiEndpoints.scannerUpload,
        imagePath,
      );

      return OcrResult.fromJson(response['result']);
    } catch (e) {
      debugPrint('[ScheduleRepository] Backend OCR error: $e');
      // Fallback to direct Gemini Vision
      return await uploadScheduleImage(imagePath);
    }
  }

  /// Get all user schedules.
  ///
  /// TODO: Fetch from MongoDB via backend.
  Future<List<ScheduleEntry>> getSchedules(String userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.schedule}?userId=$userId',
      );

      final schedules = response['schedules'] as List?;
      if (schedules == null) return [];

      return schedules
          .map((s) => ScheduleEntry.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[ScheduleRepository] Get schedules error: $e');
      return [];
    }
  }

  /// Add a new schedule entry.
  ///
  /// Backend: POST /schedule
  Future<ScheduleEntry> addSchedule(ScheduleEntry schedule) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.schedule,
        schedule.toJson(),
      );

      return ScheduleEntry.fromJson(
        response['schedule'] as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('[ScheduleRepository] Add schedule error: $e');
      // Return local copy with generated ID
      return schedule.copyWith(
        id: 'sch_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
  }

  /// Update an existing schedule entry.
  ///
  /// Backend: PUT /schedule/{scheduleId}
  Future<ScheduleEntry> updateSchedule(ScheduleEntry schedule) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.scheduleDetail.replaceFirst('{scheduleId}', schedule.id),
        schedule.toJson(),
      );

      return ScheduleEntry.fromJson(
        response['schedule'] as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('[ScheduleRepository] Update schedule error: $e');
      return schedule;
    }
  }

  /// Delete a schedule entry.
  ///
  /// Backend: DELETE /schedule/{scheduleId}
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await _apiClient.delete(
        ApiEndpoints.scheduleDetail.replaceFirst('{scheduleId}', scheduleId),
      );
    } catch (e) {
      debugPrint('[ScheduleRepository] Delete schedule error: $e');
    }
  }

  /// Generate optimized study schedule using Genetic Algorithm.
  ///
  /// This method calls the ML Service (FastAPI) for optimization.
  ///
  /// [userId] - User identifier
  /// [schoolSchedule] - User's existing school schedule
  /// [difficultSubjects] - Subjects user finds difficult
  /// [upcomingExams] - List of upcoming exam dates
  /// [vakStyle] - User's VAK learning style (optional)
  Future<List<ScheduleEntry>> generateOptimizedStudySchedule({
    required String userId,
    required List<ScheduleEntry> schoolSchedule,
    required List<String> difficultSubjects,
    required List<DateTime> upcomingExams,
    String? vakStyle,
  }) async {
    try {
      // Call ML Service (FastAPI) for optimization
      final response = await _apiClient
          .post('${ApiConfig.mlServiceUrl}/schedule/optimize', {
            'userId': userId,
            'schoolSchedule': schoolSchedule.map((s) => s.toJson()).toList(),
            'difficultSubjects': difficultSubjects,
            'upcomingExams': upcomingExams
                .map((e) => e.toIso8601String())
                .toList(),
            'vakStyle': vakStyle,
          });

      final schedules = response['schedules'] as List?;
      if (schedules == null) return [];

      return schedules
          .map((s) => ScheduleEntry.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[ScheduleRepository] Generate optimized schedule error: $e');

      // Fallback: Simple local scheduling algorithm
      return _generateSimpleStudySchedule(
        userId: userId,
        schoolSchedule: schoolSchedule,
        difficultSubjects: difficultSubjects,
      );
    }
  }

  /// Get schedule by ID.
  ///
  /// Backend: GET /schedule/{scheduleId}
  Future<ScheduleEntry?> getScheduleById(String scheduleId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.scheduleDetail.replaceFirst('{scheduleId}', scheduleId),
      );

      return ScheduleEntry.fromJson(
        response['schedule'] as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('[ScheduleRepository] Get schedule by ID error: $e');
      return null;
    }
  }

  /// Extract text response from Gemini API.
  String _extractGeminiResponse(Map<String, dynamic> response) {
    try {
      final candidates = response['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        return '';
      }

      final content = candidates[0]['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List?;

      if (parts == null || parts.isEmpty) {
        return '';
      }

      final text = parts[0]['text'] as String?;
      return text ?? '';
    } catch (e) {
      debugPrint('[ScheduleRepository] Extract response error: $e');
      return '';
    }
  }

  /// Parse schedule from OCR text result.
  ///
  /// Simple parser - for production, use LLM to parse JSON.
  List<ScheduleEntry> _parseScheduleFromOCR(String rawText) {
    final schedules = <ScheduleEntry>[];

    // Simple line-by-line parsing (for demo)
    // Production: Use LLM to parse structured JSON
    final lines = rawText.split('\n');

    for (final line in lines) {
      // Try to extract: DAY: TIME Subject
      // Example: "SENIN: 07:00-08:30 Matematika"
      final dayMatch = RegExp(
        r'(SENIN|SELASA|RABU|KAMIS|JUMAT|SABTU)[:\s]+(\d{1,2}:\d{2})\s*[-–]\s*(\d{1,2}:\d{2})\s+(.+)',
        caseSensitive: false,
      ).firstMatch(line);

      if (dayMatch != null) {
        final day = dayMatch.group(1)?.toUpperCase() ?? '';
        final startTime = dayMatch.group(2) ?? '';
        final endTime = dayMatch.group(3) ?? '';
        final subject = dayMatch.group(4)?.trim() ?? '';

        if (subject.isNotEmpty) {
          schedules.add(
            ScheduleEntry(
              id: 'sch_${DateTime.now().millisecondsSinceEpoch + schedules.length}',
              userId: 'user_temp',
              subject: subject,
              subjectCode: _getSubjectCode(subject),
              startTime: _parseTime(day, startTime),
              endTime: _parseTime(day, endTime),
              location: '',
              isRecurring: true,
              recurringDays: [_dayToRecurringDay(day)],
              createdAt: DateTime.now(),
            ),
          );
        }
      }
    }

    return schedules;
  }

  /// Get subject code from subject name.
  String _getSubjectCode(String subject) {
    final subjectLower = subject.toLowerCase();
    if (subjectLower.contains('matematika')) return 'MTK';
    if (subjectLower.contains('fisika')) return 'FIS';
    if (subjectLower.contains('kimia')) return 'KIM';
    if (subjectLower.contains('biologi')) return 'BIO';
    if (subjectLower.contains('bahasa indonesia')) return 'IND';
    if (subjectLower.contains('bahasa inggris')) return 'ING';
    if (subjectLower.contains('sejarah')) return 'SEJ';
    if (subjectLower.contains('geografi')) return 'GEO';
    if (subjectLower.contains('sosiologi')) return 'SOS';
    if (subjectLower.contains('ekonomi')) return 'EKO';
    if (subjectLower.contains('pkn')) return 'PKN';
    if (subjectLower.contains('agama')) return 'AGM';
    if (subjectLower.contains('olahraga')) return 'ORKES';
    if (subjectLower.contains('seni')) return 'SEN';
    if (subjectLower.contains('tik') || subjectLower.contains('informatika'))
      return 'TIK';
    return 'UNK';
  }

  /// Parse time string to DateTime.
  DateTime _parseTime(String day, String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.tryParse(parts[0]) ?? 7;
    final minute = int.tryParse(parts[1]) ?? 0;

    // Use current week's day
    final now = DateTime.now();
    int dayOfWeek = 1; // Monday default

    switch (day.toUpperCase()) {
      case 'SENIN':
        dayOfWeek = 1;
        break;
      case 'SELASA':
        dayOfWeek = 2;
        break;
      case 'RABU':
        dayOfWeek = 3;
        break;
      case 'KAMIS':
        dayOfWeek = 4;
        break;
      case 'JUMAT':
        dayOfWeek = 5;
        break;
      case 'SABTU':
        dayOfWeek = 6;
        break;
    }

    // Calculate next occurrence of this day
    int daysUntilTarget = dayOfWeek - now.weekday;
    if (daysUntilTarget < 0) daysUntilTarget += 7;

    final targetDate = now.add(Duration(days: daysUntilTarget));

    return DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      hour,
      minute,
    );
  }

  /// Convert day string to recurring day code.
  String _dayToRecurringDay(String day) {
    switch (day.toUpperCase()) {
      case 'SENIN':
        return 'MON';
      case 'SELASA':
        return 'TUE';
      case 'RABU':
        return 'WED';
      case 'KAMIS':
        return 'THU';
      case 'JUMAT':
        return 'FRI';
      case 'SABTU':
        return 'SAT';
      default:
        return 'MON';
    }
  }

  /// Get MIME type from file extension.
  String _getMimeType(String path) {
    if (path.endsWith('.png')) return 'image/png';
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return 'image/jpeg';
    if (path.endsWith('.gif')) return 'image/gif';
    if (path.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  /// Simple fallback study schedule generator.
  List<ScheduleEntry> _generateSimpleStudySchedule({
    required String userId,
    required List<ScheduleEntry> schoolSchedule,
    required List<String> difficultSubjects,
  }) {
    final studySchedule = <ScheduleEntry>[];

    // Schedule difficult subjects in evening (19:00-20:30)
    // This is a simple algorithm - production uses Genetic Algorithm
    int dayOffset = 0;
    for (final subject in difficultSubjects) {
      final studyTime = DateTime.now().add(
        Duration(days: dayOffset, hours: 19),
      );

      studySchedule.add(
        ScheduleEntry(
          id: 'study_${DateTime.now().millisecondsSinceEpoch + dayOffset}',
          userId: userId,
          subject: subject,
          subjectCode: _getSubjectCode(subject),
          startTime: studyTime,
          endTime: studyTime.add(const Duration(hours: 1, minutes: 30)),
          location: 'Rumah',
          notes: 'Fokus pada $subject',
          isRecurring: true,
          recurringDays: ['MON', 'WED', 'FRI'],
          createdAt: DateTime.now(),
        ),
      );

      dayOffset++;
    }

    return studySchedule;
  }
}

/// Provider for the schedule repository.
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository(
    ref.watch(apiClientProvider),
    ApiClient(baseUrl: ApiConfig.geminiBaseUrl),
  );
});
