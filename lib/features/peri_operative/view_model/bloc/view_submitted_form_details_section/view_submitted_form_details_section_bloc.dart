import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/model/view_patient_submitted_form_details_model.dart';

part 'view_submitted_form_details_section_event.dart';

part 'view_submitted_form_details_section_state.dart';

class ViewSubmittedFormDetailsSectionBloc
    extends
        Bloc<
          ViewSubmittedFormDetailsSectionEvent,
          ViewSubmittedFormDetailsSectionState
        > {
  final GraphQLService graphQLService;

  ViewSubmittedFormDetailsSectionBloc({required this.graphQLService})
    : super(ViewSubmittedFormDetailsSectionInitial()) {
    on<GetViewSubmittedFormDetailsEvent>((event, emit) async {
      emit(GetViewSubmittedFormDetailsSectionLoading());

      try {
        final query =
            '''
        query View_submited_patient_form_detail_section__ {
  view_submited_patient_form_detail_section__(
    user_id: "${event.userId}"
    patient_form_id: "${event.patientFormId}"
  ) {
    patient_status_form
    status
    title
    total_points
    user_id {
      id
      last_name
      first_name
    }
    createdAt_time
    doctor_id {
      id
      last_name
      first_name
    }
    form_no
    form_serial_no
    form_status
    form_type
    id
    form_section {
      form_index_no
      id
      section_title
      form_option {
        answer_status
        option_name
        points
      }
    }
  }
}
   ''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException) {
          emit(
            GetViewSubmittedFormDetailsSectionFailure(
              message: result.exception.toString(),
            ),
          );
          return;
        }

        final data =
            result.data?['view_submited_patient_form_detail_section__'];
        if (data == null) {
          emit(
            GetViewSubmittedFormDetailsSectionFailure(message: "No data found"),
          );
          return;
        }

        final submittedForm = ViewPatientSubmittedFormDetailsModel.fromJson(
          data,
        );

        emit(
          GetViewSubmittedFormDetailsSectionSuccess(formDetails: submittedForm),
        );
      } catch (e) {
        emit(GetViewSubmittedFormDetailsSectionFailure(message: e.toString()));
      }
    });
  }
}
