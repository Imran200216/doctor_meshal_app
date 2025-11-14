part of 'education_articles_bloc.dart';

sealed class EducationArticlesEvent extends Equatable {
  const EducationArticlesEvent();
}

final class GetEducationArticlesEvent extends EducationArticlesEvent {
  final String id;
  final String userId;

  const GetEducationArticlesEvent({required this.id, required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [id, userId];
}
