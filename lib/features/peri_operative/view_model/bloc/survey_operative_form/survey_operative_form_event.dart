part of 'survey_operative_form_bloc.dart';

sealed class SurveyOperativeFormEvent extends Equatable {
  const SurveyOperativeFormEvent();
}

class GetSurveyOperativeForm extends SurveyOperativeFormEvent {
  final String userId;
  final String id;

  const GetSurveyOperativeForm({required this.userId, required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [userId, id];
}

class AddSurveyOperativeForm extends SurveyOperativeFormEvent {
  final String userId;
  final String operativeFormId;
  final String totalPoints;
  final String inputForm;

  const AddSurveyOperativeForm({
    required this.userId,
    required this.operativeFormId,
    required this.totalPoints,
    required this.inputForm,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [userId, operativeFormId, totalPoints, inputForm];
}
