import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(LocalizationInitial());

  String? selectedLanguage;

  void selectLanguage(String language) {
    selectedLanguage = language;

    emit(LocalizationSelected(selectedLanguage: language));
  }

  void clearLanguage() {
    selectedLanguage = null;

    emit(LocalizationInitial());
  }
}
