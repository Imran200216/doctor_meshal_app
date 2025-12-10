part of 'survey_form_selection_cubit.dart';

abstract class SurveyFormSelectionState extends Equatable {
  const SurveyFormSelectionState();

  @override
  List<Object?> get props => [];
}

class SurveyFormSelectionInitial extends SurveyFormSelectionState {}

class SurveyFormSelected extends SurveyFormSelectionState {
  final Map<int, int?> singleSelections;         // single choice
  final Map<int, List<int>> multiSelections;     // multiple choice
  final Map<int, String> answerTexts;            // text answers

  const SurveyFormSelected({
    required this.singleSelections,
    required this.multiSelections,
    required this.answerTexts,
  });

  @override
  List<Object?> get props => [singleSelections, multiSelections, answerTexts];
}
