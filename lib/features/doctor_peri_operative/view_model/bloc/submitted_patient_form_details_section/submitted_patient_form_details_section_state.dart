part of 'submitted_patient_form_details_section_bloc.dart';

sealed class SubmittedPatientFormDetailsSectionState extends Equatable {
  const SubmittedPatientFormDetailsSectionState();
}

final class SubmittedPatientFormDetailsSectionInitial
    extends SubmittedPatientFormDetailsSectionState {
  @override
  List<Object> get props => [];
}

final class GetSubmittedPatientFormDetailsSectionLoading
    extends SubmittedPatientFormDetailsSectionState {
  @override
  List<Object> get props => [];
}

final class GetSubmittedPatientFormDetailsSectionSuccess
    extends SubmittedPatientFormDetailsSectionState {
  final ViewSubmittedPatientFormDetailsSectionModel data;

  const GetSubmittedPatientFormDetailsSectionSuccess({required this.data});

  @override
  // TODO: implement props
  List<Object?> get props => [data];
}

final class GetSubmittedPatientFormDetailsSectionFailure
    extends SubmittedPatientFormDetailsSectionState {
  final String message;

  const GetSubmittedPatientFormDetailsSectionFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
