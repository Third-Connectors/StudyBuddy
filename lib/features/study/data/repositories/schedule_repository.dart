import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/schedule_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/providers/supabase_provider.dart';

/// Repository for Schedule Scanner using Supabase and Gemini Vision.
class ScheduleRepository {
  final supabase.SupabaseClient _supabase;
  final ApiClient _geminiClient;
  final ImagePicker _imagePicker;

  ScheduleRepository(this._supabase, this._geminiClient)
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

  /// Upload schedule image for OCR processing with Gemini Vision.
  Future<OcrResult> uploadScheduleImage(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);
      final mimeType = _getMimeType(imagePath);

      final ocrPrompt = '''
Anda adalah sistem OCR khusus untuk jadwal pelajaran sekolah Indonesia (SMA/MA/SMK).
Tugas Anda:
1. Baca dan ekstrak semua informasi dari gambar jadwal ini
2. Identifikasi: Hari, Mata Pelajaran, Waktu Mulai, Waktu Selesai, Ruang (jika ada)
3. Format hasil dalam struktur JSON yang rapi

Format Output JSON:
{
  "rawText": "teks lengkap yang terbaca",
  "schedules": [
    {
      "day": "SENIN",
      "subject": "Matematika",
      "startTime": "07:00",
      "endTime": "08:30",
      "location": "Ruang 101"
    }
  ]
}''';

      final response = await _geminiClient.post(
        'models/${ApiConfig.geminiVisionModel}:generateContent',
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
        },
        queryParameters: {'key': ApiConfig.geminiApiKey},
      );

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
      throw Exception('Gagal memproses gambar: $e');
    }
  }

  /// Get active schedule from Supabase.
  Future<List<ScheduleEntry>> getSchedules(String userId) async {
    try {
      final response = await _supabase
          .from('schedules')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) return [];

      final List items = response['items'] as List;
      return items
          .map((s) => ScheduleEntry.fromJson(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('[ScheduleRepository] Get schedules error: $e');
      return [];
    }
  }

  /// Save/Update entire schedule to Supabase.
  Future<void> saveSchedule(String userId, List<ScheduleEntry> entries) async {
    try {
      final itemsJson = entries.map((e) => e.toJson()).toList();

      await _supabase.from('schedules').upsert({
        'user_id': userId,
        'title': 'Jadwal Sekolah Utama',
        'items': itemsJson,
        'is_active': true,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId);

      debugPrint('[ScheduleRepository] Schedule saved to Supabase');
    } catch (e) {
      debugPrint('[ScheduleRepository] Save schedule error: $e');
      throw Exception('Gagal menyimpan jadwal: $e');
    }
  }

  /// Add a single schedule entry to Supabase.
  Future<ScheduleEntry> addSchedule(ScheduleEntry entry) async {
    try {
      final userId = _supabase.auth.currentUser?.id ?? entry.userId;

      // Get existing schedule
      final existing = await getSchedules(userId);
      final updated = [...existing, entry];

      // Save all
      await saveSchedule(userId, updated);

      return entry;
    } catch (e) {
      debugPrint('[ScheduleRepository] Add schedule error: $e');
      throw Exception('Gagal menambah jadwal: $e');
    }
  }

  /// Delete a schedule entry by ID.
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final existing = await getSchedules(userId);
      final updated = existing.where((s) => s.id != scheduleId).toList();

      await saveSchedule(userId, updated);

      debugPrint('[ScheduleRepository] Schedule $scheduleId deleted');
    } catch (e) {
      debugPrint('[ScheduleRepository] Delete schedule error: $e');
      throw Exception('Gagal menghapus jadwal: $e');
    }
  }

  /// Generate optimized study schedule using Gemini AI.
  Future<List<ScheduleEntry>> generateOptimizedStudySchedule({
    required String userId,
    required String vakStyle,
    required List<ScheduleEntry> existingSchedule,
    List<String>? weakSubjects,
  }) async {
    try {
      final subjects = existingSchedule.map((e) => e.subject).toSet().toList();
      final subjectList = subjects.join(', ');
      final weakList = weakSubjects?.join(', ') ?? '';

      final prompt = '''
Buatkan jadwal belajar mingguan untuk siswa $vakStyle.
Mata pelajaran: $subjectList.
${weakList.isNotEmpty ? 'Mata pelajaran yang perlu diperkuat: $weakList.' : ''}
Waktu belajar: 16:00 - 21:00.
Format respons: JSON array.
[{"day": "Senin", "subject": "Math", "startTime": "16:00", "endTime": "17:30"}]''';

      final response = await _geminiClient.post(
        'models/${ApiConfig.geminiModel}:generateContent',
        {
          'contents': [{'parts': [{'text': prompt}]}],
        },
        queryParameters: {'key': ApiConfig.geminiApiKey},
      );

      final aiText = _extractGeminiResponse(response);
      return _parseOptimizedSchedule(aiText, userId);
    } catch (e) {
      debugPrint('[ScheduleRepository] Optimization error: $e');
      return [];
    }
  }

  // --- Helper Methods ---

  String _extractGeminiResponse(Map<String, dynamic> response) {
    try {
      return response['candidates'][0]['content']['parts'][0]['text'] ?? '';
    } catch (e) {
      return '';
    }
  }

  List<ScheduleEntry> _parseScheduleFromOCR(String rawText) {
    try {
      String jsonStr = rawText;
      if (rawText.contains('```json')) {
        jsonStr = rawText.split('```json')[1].split('```')[0].trim();
      }
      final data = jsonDecode(jsonStr);
      final List schedulesJson = data['schedules'] ?? [];

      return schedulesJson.map((s) {
        final day = s['day'] ?? 'SENIN';
        return ScheduleEntry(
          id: 'sch_${DateTime.now().millisecondsSinceEpoch}_${s.hashCode}',
          userId: 'current',
          subject: s['subject'] ?? '',
          subjectCode: 'UNK',
          startTime: _parseTime(day, s['startTime'] ?? '07:00'),
          endTime: _parseTime(day, s['endTime'] ?? '08:30'),
          location: s['location'] ?? '',
          createdAt: DateTime.now(),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  List<ScheduleEntry> _parseOptimizedSchedule(String jsonText, String userId) {
    try {
      final startIdx = jsonText.indexOf('[');
      final endIdx = jsonText.lastIndexOf(']');
      final jsonStr = jsonText.substring(startIdx, endIdx + 1);
      final List items = jsonDecode(jsonStr);

      return items.map((item) {
        final day = item['day'] ?? 'Senin';
        return ScheduleEntry(
          id: 'opt_${DateTime.now().millisecondsSinceEpoch}_${item.hashCode}',
          userId: userId,
          subject: item['subject'] ?? '',
          subjectCode: 'UNK',
          startTime: _parseTime(day, item['startTime'] ?? '16:00'),
          endTime: _parseTime(day, item['endTime'] ?? '17:30'),
          location: 'Rumah',
          createdAt: DateTime.now(),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  DateTime _parseTime(String day, String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.tryParse(parts[0]) ?? 7;
    final minute = int.tryParse(parts[1]) ?? 0;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String _getMimeType(String path) {
    if (path.endsWith('.png')) return 'image/png';
    return 'image/jpeg';
  }
}

/// Provider for the schedule repository.
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository(
    ref.watch(supabaseClientProvider),
    ApiClient(baseUrl: ApiConfig.geminiBaseUrl),
  );
});
