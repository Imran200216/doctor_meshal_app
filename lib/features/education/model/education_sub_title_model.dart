import 'package:equatable/equatable.dart';

class EducationSubTitleModel extends Equatable {
  final String id;
  final String image;
  final String subTitleName;
  final String educationArticleCounts;

  const EducationSubTitleModel({
    required this.id,
    required this.image,
    required this.subTitleName,
    required this.educationArticleCounts,
  });

  factory EducationSubTitleModel.fromJson(Map<String, dynamic> json) {
    return EducationSubTitleModel(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      subTitleName: json['sub_title_name'] ?? '',
      educationArticleCounts: json['education_article_counts'] ?? '0',
    );
  }

  @override
  List<Object> get props => [id, image, subTitleName, educationArticleCounts];
}
