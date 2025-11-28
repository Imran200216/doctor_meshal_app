import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/model/status_form_model.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'status_form_event.dart';

part 'status_form_state.dart';

class StatusFormBloc extends Bloc<StatusFormEvent, StatusFormState> {
  final GraphQLService graphQLService;

  StatusFormBloc({required this.graphQLService}) : super(StatusFormInitial()) {
    // Get Status Form Event
    on<GetStatusFormEvent>((event, emit) async {
      emit(StatusFormLoading());

      try {
        AppLoggerHelper.logInfo(
          "Fetching patient forms for user: ${event.userId}",
        );

        String query =
            ''' 
        query Get_patient_forms_history {
          get_patient_forms_history(user_id: "${event.userId}") {
            form_serial_no
            form_status
            id
            title
            form_no
            form_type
            patient_status_form
            status
          }
        }
        ''';

        final result = await graphQLService.performQuery(query);

        if (result.data == null ||
            result.data?['get_patient_forms_history'] == null) {
          AppLoggerHelper.logError("No forms found for user: ${event.userId}");
          emit(StatusFormFailure(message: "No forms found"));
          return;
        }

        final formsJson = result.data?['get_patient_forms_history'] as List?;
        if (formsJson == null) {
          AppLoggerHelper.logError("No forms found for user: ${event.userId}");
          emit(StatusFormFailure(message: "No forms found"));
          return;
        }

        final forms = formsJson
            .map((e) => StatusFormModel.fromJson(e))
            .toList();

        AppLoggerHelper.logInfo(
          "Fetched ${forms.length} patient forms successfully",
        );

        emit(StatusFormSuccess(status: forms));
      } catch (e, stackTrace) {
        AppLoggerHelper.logError("Error fetching patient forms: $e");
        AppLoggerHelper.logError(stackTrace.toString());
        emit(StatusFormFailure(message: e.toString()));
      }
    });
  }
}
