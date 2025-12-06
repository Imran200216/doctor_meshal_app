part of 'education_sub_title_bloc.dart';

sealed class EducationSubTitleState extends Equatable {
  const EducationSubTitleState();
}

final class EducationSubTitleInitial extends EducationSubTitleState {
  @override
  List<Object> get props => [];
}

final class EducationSubTitleLoading extends EducationSubTitleState {
  @override
  List<Object> get props => [];
}

class EducationSubTitleSuccess extends EducationSubTitleState {
  final List<EducationSubTitleModel> subtitles;
  final String mainTitle;

  const EducationSubTitleSuccess({
    required this.subtitles,
    required this.mainTitle,
  });

  @override
  List<Object> get props => [subtitles, mainTitle];
}

class EducationSubTitleOfflineSuccess extends EducationSubTitleState {
  final List<EducationSubTitleModel> subtitles;
  final String mainTitle;

  const EducationSubTitleOfflineSuccess({
    required this.subtitles,
    required this.mainTitle,
  });

  @override
  List<Object> get props => [subtitles, mainTitle];
}

final class EducationSubTitleFailure extends EducationSubTitleState {
  final String message;

  const EducationSubTitleFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
