class EducationFullViewArticle {
  final String id;
  final String articleName;
  final String article;
  final String titleName;
  final String subTitleName;

  EducationFullViewArticle({
    required this.id,
    required this.articleName,
    required this.article,
    required this.titleName,
    required this.subTitleName,
  });

  factory EducationFullViewArticle.fromJson(Map<String, dynamic> json) {
    return EducationFullViewArticle(
      id: json['id'] ?? "",
      articleName: json['article_name'] ?? "",
      article: json['article'] ?? "",
      titleName: json['title_name'] ?? "",
      subTitleName: json['sub_title_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'article_name': articleName,
      'article': article,
      'title_name': titleName,
      'sub_title_name': subTitleName,
    };
  }
}
