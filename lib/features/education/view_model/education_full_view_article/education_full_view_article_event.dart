part of 'education_full_view_article_bloc.dart';

sealed class EducationFullViewArticleEvent extends Equatable {
  const EducationFullViewArticleEvent();
}

class GetEducationFullViewArticleEvent extends EducationFullViewArticleEvent {
  final String id;
  final String userId;

  const GetEducationFullViewArticleEvent({
    required this.id,
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, userId];
}
