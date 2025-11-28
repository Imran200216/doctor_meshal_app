part of 'view_submitted_form_details_section_bloc.dart';

sealed class ViewSubmittedFormDetailsSectionEvent extends Equatable {
  const ViewSubmittedFormDetailsSectionEvent();
}

final class GetViewSubmittedFormDetailsEvent
    extends ViewSubmittedFormDetailsSectionEvent {
  final String userId;
  final String patientFormId;

  const GetViewSubmittedFormDetailsEvent({
    required this.userId,
    required this.patientFormId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [userId, patientFormId];
}
