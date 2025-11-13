class Education {
  final String id;
  final String image;
  final String title;
  final int subTitleCounts;

  Education({
    required this.id,
    required this.image,
    required this.title,
    required this.subTitleCounts,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      subTitleCounts: int.tryParse(json['sub_title_counts'].toString()) ?? 0,
    );
  }
}
