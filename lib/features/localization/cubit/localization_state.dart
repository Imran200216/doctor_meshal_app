part of 'localization_cubit.dart';

sealed class LocalizationState extends Equatable {
  const LocalizationState();
}

final class LocalizationInitial extends LocalizationState {
  @override
  List<Object> get props => [];
}

final class LocalizationSelected extends LocalizationState {
  final String selectedLanguage;

  const LocalizationSelected({required this.selectedLanguage});

  @override
  // TODO: implement props
  List<Object?> get props => [selectedLanguage];
}
