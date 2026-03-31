import 'dart:io';

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

    state = state.copyWith(isSaving: true, error: null);

    try {
      // Save each extracted schedule
      for (final schedule in state.ocrResult!.extractedSchedules) {
        await _scheduleRepository.addSchedule(schedule);
      }

      state = state.copyWith(
        schedules: [...state.schedules, ...state.ocrResult!.extractedSchedules],
        isSaving: false,
        ocrResult: null,
        selectedImage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Gagal menyimpan jadwal: $e',
      );
    }
  }

  /// Load user's schedules.
  Future<void> loadSchedules(String userId) async {
    state = state.copyWith(error: null);

    try {
      final schedules = await _scheduleRepository.getSchedules(userId);
      state = state.copyWith(schedules: schedules);
    } catch (e) {
      state = state.copyWith(error: 'Gagal memuat jadwal: $e');
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

  /// Generate optimized study schedule.
  Future<void> generateOptimizedSchedule({
    required String userId,
    required List<String> difficultSubjects,
    required List<DateTime> upcomingExams,
  }) async {
    state = state.copyWith(isScanning: true, error: null);

    try {
      final optimizedSchedules = await _scheduleRepository
          .generateOptimizedStudySchedule(
            userId: userId,
            schoolSchedule: state.schedules,
            difficultSubjects: difficultSubjects,
            upcomingExams: upcomingExams,
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
