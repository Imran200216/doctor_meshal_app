import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';

part 'doctor_review_patient_submitted_operation_forms_event.dart';

part 'doctor_review_patient_submitted_operation_forms_state.dart';

class DoctorReviewPatientSubmittedOperationFormsBloc
    extends
        Bloc<
          DoctorReviewPatientSubmittedOperationFormsEvent,
          DoctorReviewPatientSubmittedOperationFormsState
        > {
  final GraphQLService graphQLService;

  DoctorReviewPatientSubmittedOperationFormsBloc({required this.graphQLService})
    : super(DoctorReviewPatientSubmittedOperationFormsInitial()) {


    on<AddDoctorReviewPatientSubmittedOperationFormsEvent>((event, emit) async {
      emit(DoctorReviewPatientSubmittedOperationFormsLoading());

      try {
        final mutation =
            '''
mutation Doctor_review_patient_submited_operative_forms_ {
  doctor_review_patient_submited_operative_forms_(
    user_id: "${event.userId}"
    patient_id: "${event.patientId}"
    operative_form_id: "${event.operativeFormId}"
    status: "${event.status}"
    remarks: "${event.remarks}"
  )
}
        ''';

        final result = await graphQLService.performMutation(mutation);

        // Parse Success Response
        final response =
            result.data?['doctor_review_patient_submited_operative_forms_'];

        if (response != null) {
          emit(
            DoctorReviewPatientSubmittedOperationFormsSuccess(
              message: response.toString(),
            ),
          );
        } else {
          emit(
            const DoctorReviewPatientSubmittedOperationFormsFailure(
              message: "Something went wrong",
            ),
          );
        }
      } catch (e) {
        emit(
          DoctorReviewPatientSubmittedOperationFormsFailure(
            message: e.toString(),
          ),
        );
      }
    });
  }
}
