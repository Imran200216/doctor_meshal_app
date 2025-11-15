part of 'survey_operative_form_bloc.dart';

sealed class SurveyOperativeFormState extends Equatable {
  const SurveyOperativeFormState();
}

final class SurveyOperativeFormInitial extends SurveyOperativeFormState {
  @override
  List<Object> get props => [];
}

final class SurveyOperativeFormLoading extends SurveyOperativeFormState {
  @override
  List<Object> get props => [];
}

final class SurveyOperativeFormSuccess extends SurveyOperativeFormState {
  final SurveyOperativeForm surveyOperativeForm;

  const SurveyOperativeFormSuccess({required this.surveyOperativeForm});

  @override
  // TODO: implement props
  List<Object?> get props => [surveyOperativeForm];
}

final class SurveyOperativeFormError extends SurveyOperativeFormState {
  final String message;

  const SurveyOperativeFormError({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

// Add SurveyOperativeForm
class AddSurveyOperativeFormLoading extends SurveyOperativeFormState {
  @override
  List<Object> get props => [];
}

class AddSurveyOperativeFormSuccess extends SurveyOperativeFormState {
  final String message;
  final bool success;

  const AddSurveyOperativeFormSuccess({
    required this.message,
    required this.success,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, success];
}

class AddSurveyOperativeFormError extends SurveyOperativeFormState {
  final String message;
  final bool success;

  const AddSurveyOperativeFormError({
    required this.message,
    required this.success,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, success];
}
