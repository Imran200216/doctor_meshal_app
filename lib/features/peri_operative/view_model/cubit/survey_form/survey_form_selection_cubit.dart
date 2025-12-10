import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'survey_form_selection_state.dart';

class SurveyFormSelectionCubit extends Cubit<SurveyFormSelectionState> {
  SurveyFormSelectionCubit()
      : super(const SurveyFormSelected(
    singleSelections: {},
    multiSelections: {},
    answerTexts: {},
  ));

  // SINGLE-SELECT
  void selectSingleOption(int stepIndex, int optionIndex) {
    final current = state as SurveyFormSelected;

    final updated = Map<int, int?>.from(current.singleSelections);
    updated[stepIndex] = optionIndex;

    emit(SurveyFormSelected(
      singleSelections: updated,
      multiSelections: current.multiSelections,
      answerTexts: current.answerTexts,
    ));
  }

  // MULTI-SELECT
  // In SurveyFormSelectionCubit
  void toggleMultiOption(int sectionIndex, int optionIndex) {
    final currentState = state as SurveyFormSelected;

    // Create new maps with the updated values
    final newMultiSelections = Map<int, List<int>>.from(currentState.multiSelections);

    // Get or create the list for this section
    List<int> sectionSelections = List<int>.from(newMultiSelections[sectionIndex] ?? []);

    // Toggle the option
    if (sectionSelections.contains(optionIndex)) {
      sectionSelections.remove(optionIndex);
    } else {
      sectionSelections.add(optionIndex);
    }

    // Sort to maintain consistent order
    sectionSelections.sort();

    // Update the map
    newMultiSelections[sectionIndex] = sectionSelections;

    // Emit new state
    emit(SurveyFormSelected(
      singleSelections: Map<int, int>.from(currentState.singleSelections),
      multiSelections: newMultiSelections,
      answerTexts: Map<int, String>.from(currentState.answerTexts),
    ));
  }

  // TEXT ANSWER
  void updateAnswer(int stepIndex, String value) {
    final current = state as SurveyFormSelected;

    final updated = Map<int, String>.from(current.answerTexts);
    updated[stepIndex] = value;

    emit(SurveyFormSelected(
      singleSelections: current.singleSelections,
      multiSelections: current.multiSelections,
      answerTexts: updated,
    ));
  }

  // CLEAR ALL
  void clearOptions() {
    emit(const SurveyFormSelected(
      singleSelections: {},
      multiSelections: {},
      answerTexts: {},
    ));
  }
}
