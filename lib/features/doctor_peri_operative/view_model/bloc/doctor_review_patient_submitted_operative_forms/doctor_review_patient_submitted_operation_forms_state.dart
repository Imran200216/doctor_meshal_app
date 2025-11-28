part of 'doctor_review_patient_submitted_operation_forms_bloc.dart';

sealed class DoctorReviewPatientSubmittedOperationFormsState extends Equatable {
  const DoctorReviewPatientSubmittedOperationFormsState();
}

final class DoctorReviewPatientSubmittedOperationFormsInitial
    extends DoctorReviewPatientSubmittedOperationFormsState {
  @override
  List<Object> get props => [];
}

final class DoctorReviewPatientSubmittedOperationFormsLoading
    extends DoctorReviewPatientSubmittedOperationFormsState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class DoctorReviewPatientSubmittedOperationFormsSuccess
    extends DoctorReviewPatientSubmittedOperationFormsState {
  final String message;

  const DoctorReviewPatientSubmittedOperationFormsSuccess({
    required this.message,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

final class DoctorReviewPatientSubmittedOperationFormsFailure
    extends DoctorReviewPatientSubmittedOperationFormsState {
  final String message;

  const DoctorReviewPatientSubmittedOperationFormsFailure({
    required this.message,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
