import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/home/model/view_submitted_patient_form_details_section_model.dart';

part 'submitted_patient_form_details_section_event.dart';

part 'submitted_patient_form_details_section_state.dart';

class SubmittedPatientFormDetailsSectionBloc
    extends
        Bloc<
          SubmittedPatientFormDetailsSectionEvent,
          SubmittedPatientFormDetailsSectionState
        > {
  final GraphQLService graphQLService;

  SubmittedPatientFormDetailsSectionBloc({required this.graphQLService})
    : super(SubmittedPatientFormDetailsSectionInitial()) {
    // Get Submitted Patient Form Details Section
    on<GetSubmittedPatientFormDetailsSectionEvent>((event, emit) async {
      emit(GetSubmittedPatientFormDetailsSectionLoading());

      try {
        String query =
            '''
        query View_submited_patient_form_detail_section__ {
          view_submited_patient_form_detail_section__(
            user_id: "${event.userId}"
            patient_form_id: "${event.patientFormId}"
          ) {
            id
            form_section {
              id
              section_title
              choose_type
              form_option {
                answer_status
                option_name
                points
              }
              form_index_no
            }
            createdAt_time
            form_status
            form_serial_no
            title
            total_points
            form_type
            updatedAt
            user_id {
              id
              last_name
              first_name
            }
          }
        }
        ''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException) {
          emit(
            GetSubmittedPatientFormDetailsSectionFailure(
              message: result.exception.toString(),
            ),
          );
          return;
        }

        final data = result.data;

        if (data == null) {
          emit(
            GetSubmittedPatientFormDetailsSectionFailure(
              message: "No data found",
            ),
          );
          return;
        }

        // Parse into model
        final model = ViewSubmittedPatientFormDetailsSectionModel.fromJson({
          "data": data,
        });

        emit(GetSubmittedPatientFormDetailsSectionSuccess(data: model));
      } catch (e) {
        emit(
          GetSubmittedPatientFormDetailsSectionFailure(message: e.toString()),
        );
      }
    });
  }
}
