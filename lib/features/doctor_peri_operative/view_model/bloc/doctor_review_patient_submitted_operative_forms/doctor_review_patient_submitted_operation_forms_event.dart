part of 'doctor_review_patient_submitted_operation_forms_bloc.dart';

sealed class DoctorReviewPatientSubmittedOperationFormsEvent extends Equatable {
  const DoctorReviewPatientSubmittedOperationFormsEvent();
}

final class AddDoctorReviewPatientSubmittedOperationFormsEvent
    extends DoctorReviewPatientSubmittedOperationFormsEvent {
  final String userId;
  final String patientId;
  final String operativeFormId;
  final String status;
  final String remarks;

  const AddDoctorReviewPatientSubmittedOperationFormsEvent({
    required this.userId,
    required this.patientId,
    required this.operativeFormId,
    required this.status,
    required this.remarks,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    userId,
    patientId,
    operativeFormId,
    status,
    remarks,
  ];
}
