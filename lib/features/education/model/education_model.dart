class Education {
  final String id;
  final String image;
  final String title;
  final String subTitleCounts;
  final String articleCounts;

  Education({
    required this.id,
    required this.image,
    required this.title,
    required this.subTitleCounts,
    required this.articleCounts,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      subTitleCounts: json['sub_title_counts']?.toString() ?? '0',
      articleCounts: json['articles_counts']?.toString() ?? '0',
    );
  }
}
