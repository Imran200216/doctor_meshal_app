part of 'education_full_view_article_bloc.dart';

sealed class EducationFullViewArticleState extends Equatable {
  const EducationFullViewArticleState();
}

final class EducationFullViewArticleInitial
    extends EducationFullViewArticleState {
  @override
  List<Object> get props => [];
}

final class EducationFullViewArticleLoading
    extends EducationFullViewArticleState {
  @override
  List<Object> get props => [];
}

final class EducationFullViewArticleSuccess
    extends EducationFullViewArticleState {
  final EducationFullViewArticle article;

  const EducationFullViewArticleSuccess({required this.article});

  @override
  // TODO: implement props
  List<Object?> get props => [article];
}

final class EducationFullViewArticleError
    extends EducationFullViewArticleState {
  final String message;

  const EducationFullViewArticleError({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
