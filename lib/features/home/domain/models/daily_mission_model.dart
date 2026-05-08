class DailyMission {
  final String id;
  final String title;
  final String description;
  final String? subject;
  final bool isCompleted;
  final int pointsReward;

  DailyMission({
    required this.id,
    required this.title,
    required this.description,
    this.subject,
    this.isCompleted = false,
    this.pointsReward = 50,
  });

  factory DailyMission.fromJson(Map<String, dynamic> json) {
    return DailyMission(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      subject: json['subject'],
      isCompleted: json['is_completed'] ?? false,
      pointsReward: (json['points_reward'] as num?)?.toInt() ?? 50,
    );
  }
}
