import 'package:equatable/equatable.dart';

/// Study schedule entry model.
class ScheduleEntry extends Equatable {
  final String id;
  final String userId;
  final String subject;
  final String subjectCode; // e.g., 'MTK', 'BIO', 'IND'
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String? notes;
  final String? teacherName;
  final bool isRecurring;
  final List<String> recurringDays; // ['MON', 'TUE', etc.]
  final DateTime createdAt;

  const ScheduleEntry({
    required this.id,
    required this.userId,
    required this.subject,
    required this.subjectCode,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.notes,
    this.teacherName,
    this.isRecurring = false,
    this.recurringDays = const [],
    required this.createdAt,
  });

  factory ScheduleEntry.fromJson(Map<String, dynamic> json) {
    return ScheduleEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      subject: json['subject'] as String,
      subjectCode: json['subjectCode'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: json['location'] as String,
      notes: json['notes'] as String?,
      teacherName: json['teacherName'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringDays: json['recurringDays'] != null
          ? List<String>.from(json['recurringDays'] as List<dynamic>)
          : [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'subject': subject,
      'subjectCode': subjectCode,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'notes': notes,
      'teacherName': teacherName,
      'isRecurring': isRecurring,
      'recurringDays': recurringDays,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ScheduleEntry copyWith({
    String? id,
    String? userId,
    String? subject,
    String? subjectCode,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? notes,
    String? teacherName,
    bool? isRecurring,
    List<String>? recurringDays,
    DateTime? createdAt,
  }) {
    return ScheduleEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subject: subject ?? this.subject,
      subjectCode: subjectCode ?? this.subjectCode,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      teacherName: teacherName ?? this.teacherName,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringDays: recurringDays ?? this.recurringDays,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    subject,
    subjectCode,
    startTime,
    endTime,
    location,
    notes,
    teacherName,
    isRecurring,
    recurringDays,
    createdAt,
  ];

  /// Get duration in minutes.
  int get durationInMinutes => endTime.difference(startTime).inMinutes;

  /// Check if schedule falls within Indonesian school hours (07:00 - 15:30).
  bool get isIndonesianSchoolHours {
    final startHour = startTime.hour;
    final endHour = endTime.hour;
    return startHour >= 7 && endHour <= 16;
  }
}

/// OCR Scan result from schedule image.
class OcrResult extends Equatable {
  final String rawText;
  final List<ScheduleEntry> extractedSchedules;
  final String? imageUrl;
  final DateTime scannedAt;

  const OcrResult({
    required this.rawText,
    required this.extractedSchedules,
    this.imageUrl,
    required this.scannedAt,
  });

  factory OcrResult.fromJson(Map<String, dynamic> json) {
    return OcrResult(
      rawText: json['rawText'] as String,
      extractedSchedules: (json['extractedSchedules'] as List<dynamic>)
          .map((e) => ScheduleEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rawText': rawText,
      'extractedSchedules': extractedSchedules.map((e) => e.toJson()).toList(),
      'imageUrl': imageUrl,
      'scannedAt': scannedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [rawText, extractedSchedules, imageUrl, scannedAt];
}
