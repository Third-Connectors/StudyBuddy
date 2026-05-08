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

  /// Helper untuk memformat DateTime menjadi HH:mm
  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Helper untuk menambahkan 2 jam ke DateTime terakhir sekolah
  String _addTwoHours(DateTime dt) {
    final hour = (dt.hour + 2) % 24;
    return '${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'SENIN';
      case 2: return 'SELASA';
      case 3: return 'RABU';
      case 4: return 'KAMIS';
      case 5: return 'JUMAT';
      case 6: return 'SABTU';
      default: return 'MINGGU';
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

      // Cari jam sekolah terakhir untuk setiap hari guna menentukan waktu mulai belajar rumah (+2 jam)
      final Map<String, DateTime> dailyLastHours = {};
      for (final entry in existingSchedule) {
        final dayName = entry.recurringDays.isNotEmpty 
            ? entry.recurringDays.first 
            : _getWeekdayName(entry.startTime.weekday);
        final endTime = entry.endTime; 
        if (!dailyLastHours.containsKey(dayName) || endTime.isAfter(dailyLastHours[dayName]!)) {
          dailyLastHours[dayName] = endTime;
        }
      }

      final lastHoursInfo = dailyLastHours.entries
          .map((e) => '- ${e.key}: Sekolah selesai pukul ${_formatTime(e.value)}, maka belajar mandiri di rumah HARUS dimulai pukul ${_addTwoHours(e.value)}')
          .join('\n');

      final prompt = '''
Anda adalah pakar manajemen waktu belajar dan asisten akademis SMA di Indonesia.
Tugas Anda adalah membuatkan jadwal belajar mandiri di rumah (study-at-home schedule) yang optimal untuk siswa dengan gaya belajar $vakStyle.

Mata pelajaran yang harus dipelajari di rumah: $subjectList.
${weakList.isNotEmpty ? 'Fokus utama (perlu porsi belajar lebih banyak/prioritas): $weakList.' : ''}

Ketentuan Waktu Mulai (PENTING: Belajar mandiri di rumah harus dimulai tepat 2 jam setelah jam sekolah terakhir selesai demi memberikan waktu istirahat perjalanan pulang bagi siswa):
$lastHoursInfo
Jika ada hari yang tidak tercantum di atas, asumsikan belajar mandiri di rumah dimulai pukul 16:00.

Ketentuan Penyusunan Jadwal:
1. Batasi waktu belajar mandiri di rumah selesai maksimal pukul 21:30 setiap harinya.
2. Sesi Belajar harus optimal (antara 45 - 90 menit per sesi).
3. Jadwal harus seimbang dan wajib menyisipkan waktu ISHOMA (Istirahat, Sholat, Makan) dan santai di sela-sela belajar (misal: pukul 17:30 - 19:00 untuk Sholat Magrib, Makan Malam, Sholat Isya) agar seimbang dan tidak melelahkan.
4. Sesuaikan metode penyusunan dengan gaya belajar $vakStyle (misal: gaya Visual diberi jeda untuk membaca ringkasan bergambar, Auditori diberi waktu mendengar audio book, Kinestetik diselingi aktivitas fisik ringan saat break).

Format respons HARUS berupa JSON array murni tanpa pembuka/penutup markdown tambahan, dengan struktur sebagai berikut:
[
  {"day": "Senin", "subject": "Belajar Matematika", "startTime": "15:00", "endTime": "16:00"},
  {"day": "Senin", "subject": "Break & Snack", "startTime": "16:00", "endTime": "16:30"},
  {"day": "Senin", "subject": "Belajar Fisika", "startTime": "16:30", "endTime": "17:30"},
  {"day": "Senin", "subject": "ISHOMA (Sholat Magrib, Makan, Isya)", "startTime": "17:30", "endTime": "19:00"},
  {"day": "Senin", "subject": "Belajar Kimia", "startTime": "19:00", "endTime": "20:00"}
]''';

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
          recurringDays: [day.toUpperCase()],
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
          recurringDays: [day.toUpperCase()],
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
