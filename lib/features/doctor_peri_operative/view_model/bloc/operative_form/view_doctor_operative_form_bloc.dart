import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/doctor_peri_operative/model/doctor_peri_operative_form_model.dart';

part 'view_doctor_operative_form_event.dart';

part 'view_doctor_operative_form_state.dart';

class ViewDoctorOperativeFormBloc
    extends Bloc<ViewDoctorOperativeFormEvent, ViewDoctorOperativeFormState> {
  final GraphQLService graphQLService;

  ViewDoctorOperativeFormBloc({required this.graphQLService})
    : super(ViewDoctorOperativeFormInitial()) {
    // Get View Doctor Operative Form Event
    on<GetViewDoctorOperativeFormEvent>((event, emit) async {
      emit(GetViewDoctorOperativeFormLoading());

      try {
        String query =
            ''' 
        query Get_patient_submited_forms_doctor_ {
          get_patient_submited_forms_doctor_(doctor_id: "${event.doctorId}", form_type: "${event.formType}", search: "") {
            form_serial_no
            form_status
            id
            title
            user_id {
              first_name
              last_name
              id
            }
            createdAt_time
          }
        }
        ''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException) {
          final exception = result.exception!;

          // Check if the error is about empty list
          if (exception.graphqlErrors.isNotEmpty) {
            final errorMessage = exception.graphqlErrors.first.message
                .toLowerCase();

            if (errorMessage.contains('empty') ||
                errorMessage.contains('no data') ||
                errorMessage.contains('not found')) {
              // Return success with empty list instead of error
              emit(
                GetViewDoctorOperativeFormSuccess(
                  forms: DoctorPeriOperativeFormModel(forms: []),
                ),
              );
              return;
            }
          }

          // For actual errors
          emit(
            GetViewDoctorOperativeFormFailure(message: exception.toString()),
          );
          return;
        }

        final rawData = result.data;

        if (rawData == null ||
            rawData["get_patient_submited_forms_doctor_"] == null) {
          // Return success with empty list
          emit(
            GetViewDoctorOperativeFormSuccess(
              forms: DoctorPeriOperativeFormModel(forms: []),
            ),
          );
          return;
        }

        // Check if the data is an empty list
        if (rawData["get_patient_submited_forms_doctor_"] is List &&
            (rawData["get_patient_submited_forms_doctor_"] as List).isEmpty) {
          emit(
            GetViewDoctorOperativeFormSuccess(
              forms: DoctorPeriOperativeFormModel(forms: []),
            ),
          );
          return;
        }

        // Convert JSON → Model
        final model = DoctorPeriOperativeFormModel.fromJson(rawData);

        emit(GetViewDoctorOperativeFormSuccess(forms: model));
      } catch (e) {
        emit(GetViewDoctorOperativeFormFailure(message: e.toString()));
      }
    });

    // Search Doctor Operative Form Event
    on<SearchDoctorOperativeFormEvent>((event, emit) async {
      emit(SearchDoctorOperativeFormLoading());

      try {
        String query =
            ''' 
        query Get_patient_submited_forms_doctor_ {
          get_patient_submited_forms_doctor_(doctor_id: "${event.doctorId}", form_type: "${event.formType}", search: "${event.search}") {
            form_serial_no
            form_status
            id
            title
            user_id {
              first_name
              last_name
              id
            }
            createdAt_time
          }
        }
        ''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException) {
          final exception = result.exception!;

          // Check if the error is about empty list
          if (exception.graphqlErrors.isNotEmpty) {
            final errorMessage = exception.graphqlErrors.first.message
                .toLowerCase();

            if (errorMessage.contains('empty') ||
                errorMessage.contains('no data') ||
                errorMessage.contains('not found')) {
              // Return success with empty list instead of error
              emit(
                SearchDoctorOperativeFormSuccess(
                  forms: DoctorPeriOperativeFormModel(forms: []),
                ),
              );
              return;
            }
          }

          // For actual errors
          emit(SearchDoctorOperativeFormFailure(message: exception.toString()));
          return;
        }

        final rawData = result.data;

        if (rawData == null ||
            rawData["get_patient_submited_forms_doctor_"] == null) {
          // Return success with empty list
          emit(
            SearchDoctorOperativeFormSuccess(
              forms: DoctorPeriOperativeFormModel(forms: []),
            ),
          );
          return;
        }

        // Check if the data is an empty list
        if (rawData["get_patient_submited_forms_doctor_"] is List &&
            (rawData["get_patient_submited_forms_doctor_"] as List).isEmpty) {
          emit(
            SearchDoctorOperativeFormSuccess(
              forms: DoctorPeriOperativeFormModel(forms: []),
            ),
          );
          return;
        }

        // Convert JSON → Model
        final model = DoctorPeriOperativeFormModel.fromJson(rawData);

        emit(SearchDoctorOperativeFormSuccess(forms: model));
      } catch (e) {
        emit(SearchDoctorOperativeFormFailure(message: e.toString()));
      }
    });
  }
}
