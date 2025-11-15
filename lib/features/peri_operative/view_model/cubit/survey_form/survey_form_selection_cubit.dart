import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'survey_form_selection_state.dart';

class SurveyFormSelectionCubit extends Cubit<SurveyFormSelectionState> {
  SurveyFormSelectionCubit() : super(SurveyFormSelectionInitial());

  // Store selected option per step
  void selectOption(int stepIndex, int optionIndex) {
    final updated = Map<int, int?>.from(state.selections);
    updated[stepIndex] = optionIndex;
    emit(SurveyFormSelected(selections: updated));
  }

  // Clear Options
  void clearOptions() {
    emit(SurveyFormSelected(selections: {}));
  }
}
