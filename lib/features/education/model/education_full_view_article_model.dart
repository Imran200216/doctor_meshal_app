class EducationFullViewArticle {
  final String id;
  final String articleName;
  final String article;

  EducationFullViewArticle({
    required this.id,
    required this.articleName,
    required this.article,
  });

  factory EducationFullViewArticle.fromJson(Map<String, dynamic> json) {
    return EducationFullViewArticle(
      id: json['id'] ?? "",
      articleName: json['article_name'] ?? "",
      article: json['article'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'article_name': articleName,
      'article': article,
    };
  }
}
