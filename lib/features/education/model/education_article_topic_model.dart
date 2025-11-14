class EducationArticleTopic {
  final String subTitleName;
  final List<EducationArticle> educationArticles;

  EducationArticleTopic({
    required this.subTitleName,
    required this.educationArticles,
  });

  factory EducationArticleTopic.fromJson(Map<String, dynamic> json) {
    return EducationArticleTopic(
      subTitleName: json['sub_title_name'] ?? "",
      educationArticles: (json['education_articles_lists'] as List<dynamic>? ?? [])
          .map((e) => EducationArticle.fromJson(e))
          .toList(),
    );
  }
}

class EducationArticle {
  final String id;
  final String articleName;

  EducationArticle({
    required this.id,
    required this.articleName,
  });

  factory EducationArticle.fromJson(Map<String, dynamic> json) {
    return EducationArticle(
      id: json['id'] ?? "",
      articleName: json['article_name'] ?? "",
    );
  }
}
