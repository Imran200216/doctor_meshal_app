part of 'education_sub_title_bloc.dart';

sealed class EducationSubTitleEvent extends Equatable {
  const EducationSubTitleEvent();
}

class GetEducationSubTitleEvent extends EducationSubTitleEvent {
  final String userId;
  final String educationTitleId;

  const GetEducationSubTitleEvent({
    required this.userId,
    required this.educationTitleId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [userId, educationTitleId];
}
