part of 'submitted_patient_form_details_section_bloc.dart';

sealed class SubmittedPatientFormDetailsSectionEvent extends Equatable {
  const SubmittedPatientFormDetailsSectionEvent();
}

final class GetSubmittedPatientFormDetailsSectionEvent
    extends SubmittedPatientFormDetailsSectionEvent {
  final String userId;
  final String patientFormId;

  const GetSubmittedPatientFormDetailsSectionEvent({
    required this.userId,
    required this.patientFormId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [userId, patientFormId];
}
