part of 'survey_form_selection_cubit.dart';

sealed class SurveyFormSelectionState extends Equatable {
  final Map<int, int?> selections;   // <-- ADD HERE

  const SurveyFormSelectionState({required this.selections});

  @override
  List<Object> get props => [selections];
}

final class SurveyFormSelectionInitial extends SurveyFormSelectionState {
  SurveyFormSelectionInitial() : super(selections: {});  // <-- empty map
}

class SurveyFormSelected extends SurveyFormSelectionState {
  const SurveyFormSelected({required Map<int, int?> selections})
      : super(selections: selections);
}
