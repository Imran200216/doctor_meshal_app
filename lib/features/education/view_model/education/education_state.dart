part of 'education_bloc.dart';

sealed class EducationState extends Equatable {
  const EducationState();
}

final class EducationInitial extends EducationState {
  @override
  List<Object> get props => [];
}

final class EducationLoading extends EducationState {
  @override
  List<Object> get props => [];
}

final class EducationSuccess extends EducationState {
  final List<Education> educations;

  const EducationSuccess(this.educations);

  @override
  List<Object> get props => [educations];
}

final class EducationFailure extends EducationState {
  final String message;

  const EducationFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props =>[message];
}
