class StudyMaterial {
  final String id;
  final String subject;
  final String topic;
  final String content;
  final DateTime createdAt;

  StudyMaterial({
    required this.id,
    required this.subject,
    required this.topic,
    required this.content,
    required this.createdAt,
  });

  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    return StudyMaterial(
      id: json['id'],
      subject: json['subject'],
      topic: json['topic'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
