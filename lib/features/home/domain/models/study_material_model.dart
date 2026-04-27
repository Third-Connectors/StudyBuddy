class StudyMaterial {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final String? contentUrl;
  final DateTime createdAt;

  StudyMaterial({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.contentUrl,
    required this.createdAt,
  });

  factory StudyMaterial.fromJson(Map<String, dynamic> json) {
    return StudyMaterial(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Umum',
      imageUrl: json['image_url'] ?? 'https://images.unsplash.com/photo-1513258496099-48168024adb0?q=80&w=500',
      contentUrl: json['content_url'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
}
