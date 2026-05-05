import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/schedule_model.dart';
import '../../data/repositories/schedule_repository.dart';

/// State for Schedule Scanner.
class ScheduleState {
  final List<ScheduleEntry> schedules;
  final OcrResult? ocrResult;
  final File? selectedImage;
  final bool isScanning;
  final bool isSaving;
  final String? error;

  const ScheduleState({
    this.schedules = const [],
    this.ocrResult,
    this.selectedImage,
    this.isScanning = false,
    this.isSaving = false,
    this.error,
  });

  ScheduleState copyWith({
    List<ScheduleEntry>? schedules,
    OcrResult? ocrResult,
    File? selectedImage,
    bool? isScanning,
    bool? isSaving,
    String? error,
  }) {
    return ScheduleState(
      schedules: schedules ?? this.schedules,
      ocrResult: ocrResult ?? this.ocrResult,
      selectedImage: selectedImage ?? this.selectedImage,
      isScanning: isScanning ?? this.isScanning,
      isSaving: isSaving ?? this.isSaving,
      error: error ?? this.error,
    );
  }
}

/// Notifier for Schedule Scanner state management.
class ScheduleNotifier extends StateNotifier<ScheduleState> {
  final ScheduleRepository _scheduleRepository;

  ScheduleNotifier(this._scheduleRepository) : super(const ScheduleState());

  /// Pick image from gallery.
  Future<void> pickImageFromGallery() async {
    try {
      final image = await _scheduleRepository.pickImageFromGallery();
      if (image != null) {
        state = state.copyWith(selectedImage: File(image.path), error: null);
      }
    } catch (e) {
      state = state.copyWith(error: 'Gagal mengambil gambar: $e');
    }
  }

  /// Take photo with camera.
  Future<void> takePhoto() async {
    try {
      final image = await _scheduleRepository.takePhoto();
      if (image != null) {
        state = state.copyWith(selectedImage: File(image.path), error: null);
      }
    } catch (e) {
      state = state.copyWith(error: 'Gagal mengambil foto: $e');
    }
  }

  /// Process the selected image with OCR.
  Future<void> processImage() async {
    if (state.selectedImage == null) return;

    state = state.copyWith(isScanning: true, error: null);

    try {
      final result = await _scheduleRepository.uploadScheduleImage(
        state.selectedImage!.path,
      );

      state = state.copyWith(ocrResult: result, isScanning: false);
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        error: 'Gagal memproses gambar: $e',
      );
    }
  }

  /// Save extracted schedules to user's calendar.
  Future<void> saveSchedules() async {
    if (state.ocrResult == null) return;

    final newSchedules = state.ocrResult!.extractedSchedules;
    state = state.copyWith(isSaving: true, error: null);

    // OPTIMISTIC UPDATE: Langsung masukkan ke list lokal agar user tidak menunggu
    final updatedSchedules = [...state.schedules, ...newSchedules];

    state = state.copyWith(
      schedules: updatedSchedules,
      isSaving: false,
      ocrResult: null,
      selectedImage: null,
    );

    // Lakukan penyimpanan ke server di background tanpa memblokir UI
    try {
      for (final schedule in newSchedules) {
        // Kita tidak memakai 'await' di sini agar proses loop tidak terhenti oleh timeout
        _scheduleRepository.addSchedule(schedule).catchError((e) {
          debugPrint(
            '[ScheduleNotifier] Background save failed for ${schedule.subject}: $e',
          );
          return schedule;
        });
      }
    } catch (e) {
      debugPrint('[ScheduleNotifier] Bulk save error: $e');
    }
  }

  /// Load user's schedules.
  Future<void> loadSchedules(String userId) async {
    state = state.copyWith(error: null);

    try {
      final schedules = await _scheduleRepository.getSchedules(userId);
      if (schedules.isNotEmpty) {
        state = state.copyWith(schedules: schedules);
      }
    } catch (e) {
      debugPrint(
        '[ScheduleNotifier] Load failed, using local/dummy fallback: $e',
      );
      // Jika gagal, biarkan jadwal yang sudah ada di state (hasil scan tadi) tetap tampil
      if (state.schedules.isEmpty) {
        // Hanya tambahkan dummy jika list benar-benar kosong
        state = state.copyWith(
          schedules: [
            ScheduleEntry(
              id: 'dummy_1',
              userId: userId,
              subject: 'Matematika (Contoh)',
              subjectCode: 'MTK',
              startTime: DateTime.now().copyWith(hour: 7, minute: 0),
              endTime: DateTime.now().copyWith(hour: 8, minute: 30),
              location: 'Ruang 101',
              isRecurring: true,
              recurringDays: ['MON'],
              createdAt: DateTime.now(),
            ),
          ],
        );
      }
    }
  }

  /// Add a new schedule manually.
  Future<void> addSchedule(ScheduleEntry schedule) async {
    try {
      final saved = await _scheduleRepository.addSchedule(schedule);
      state = state.copyWith(schedules: [...state.schedules, saved]);
    } catch (e) {
      state = state.copyWith(error: 'Gagal menambah jadwal: $e');
    }
  }

  /// Delete a schedule.
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      await _scheduleRepository.deleteSchedule(scheduleId);
      state = state.copyWith(
        schedules: state.schedules.where((s) => s.id != scheduleId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Gagal menghapus jadwal: $e');
    }
  }

  /// Clear the current scan.
  void clearScan() {
    state = state.copyWith(ocrResult: null, selectedImage: null, error: null);
  }

  /// Generate optimized study schedule using Gemini AI.
  ///
  /// [vakStyle] defaults to 'Visual' if the caller doesn't supply it;
  /// pass the actual value from the user's VAK profile when available.
  Future<void> generateOptimizedSchedule({
    required String userId,
    required List<String> difficultSubjects,
    String vakStyle = 'Visual',
  }) async {
    state = state.copyWith(isScanning: true, error: null);

    try {
      final optimizedSchedules = await _scheduleRepository
          .generateOptimizedStudySchedule(
            userId: userId,
            vakStyle: vakStyle,
            existingSchedule: state.schedules,
            weakSubjects: difficultSubjects,
          );

      state = state.copyWith(
        schedules: [...state.schedules, ...optimizedSchedules],
        isScanning: false,
      );
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        error: 'Gagal membuat jadwal: $e',
      );
    }
  }
}

/// Provider for schedule notifier.
final scheduleNotifierProvider =
    StateNotifierProvider<ScheduleNotifier, ScheduleState>((ref) {
      return ScheduleNotifier(ref.watch(scheduleRepositoryProvider));
    });
