part of 'education_articles_bloc.dart';

sealed class EducationArticlesState extends Equatable {
  const EducationArticlesState();
}

final class EducationArticlesInitial extends EducationArticlesState {
  @override
  List<Object> get props => [];
}

final class EducationArticlesLoading extends EducationArticlesState {
  @override
  List<Object> get props => [];
}

final class EducationArticlesSuccess extends EducationArticlesState {
  final List<EducationArticleTopic> topics;

  const EducationArticlesSuccess({required this.topics});

  @override
  // TODO: implement props
  List<Object?> get props => [topics];
}

final class EducationArticlesOfflineSuccess extends EducationArticlesState {
  final List<EducationArticleTopic> topics;

  const EducationArticlesOfflineSuccess({required this.topics});

  @override
  // TODO: implement props
  List<Object?> get props => [topics];
}

final class EducationArticlesFailure extends EducationArticlesState {
  final String message;

  const EducationArticlesFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
