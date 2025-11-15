import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/peri_operative/model/survey_operative_from_model.dart';

part 'survey_operative_form_event.dart';

part 'survey_operative_form_state.dart';

class SurveyOperativeFormBloc
    extends Bloc<SurveyOperativeFormEvent, SurveyOperativeFormState> {
  final GraphQLService graphQLService;

  SurveyOperativeFormBloc({required this.graphQLService})
    : super(SurveyOperativeFormInitial()) {
    // Get Survey Operative Form
    on<GetSurveyOperativeForm>((event, emit) async {
      emit(SurveyOperativeFormLoading());

      try {
        String query =
            '''
    query View_operative_form_patient {
      view_operative_form_patient(user_id: "${event.userId}", id_: "${event.id}") {
        title
        id
        form_section {
          form_index_no
          choose_type
          id
          section_title
          form_option {
            option_name
            points
          }
        }
      }
    }
    ''';

        final result = await graphQLService.performQuery(query);

        if (result.hasException) {
          emit(SurveyOperativeFormError(message: result.exception.toString()));
          return;
        }

        if (result.data == null ||
            result.data!["view_operative_form_patient"] == null) {
          emit(const SurveyOperativeFormError(message: "No data found"));
          return;
        }

        final data = result.data!["view_operative_form_patient"];

        final form = SurveyOperativeForm.fromJson(data);

        emit(SurveyOperativeFormSuccess(surveyOperativeForm: form));
      } catch (e) {
        emit(SurveyOperativeFormError(message: e.toString()));
      }
    });

    // Add Survey Operative Form
    on<AddSurveyOperativeForm>((event, emit) async {
      emit(AddSurveyOperativeFormLoading());
      AppLoggerHelper.logInfo(
        "AddSurveyOperativeForm event triggered with userId: ${event.userId}, operativeFormId: ${event.operativeFormId}, totalPoints: ${event.totalPoints}, inputForm: ${event.inputForm}",
      );

      try {
        String mutation =
            '''
mutation Patient_form_submits {
  patient_form_submits(
    user_id: "${event.userId}"
    operative_form_id: "${event.operativeFormId}"
    total_points: "${event.totalPoints}"
    input_form: ${event.inputForm}
  ) {
    message
    status
  }
}
''';

        AppLoggerHelper.logInfo("GraphQL Mutation: $mutation");

        final result = await graphQLService.performMutation(mutation);

        if (result.hasException) {
          AppLoggerHelper.logError(
            "GraphQL Exception: ${result.exception.toString()}",
          );
          emit(
            AddSurveyOperativeFormError(
              message: result.exception.toString(),
              success: false,
            ),
          );
          return;
        }

        final response = result.data?["patient_form_submits"];
        AppLoggerHelper.logInfo("GraphQL Response: $response");

        if (response == null) {
          AppLoggerHelper.logError("No response from server");
          emit(
            const AddSurveyOperativeFormError(
              message: "No response from server",
              success: false,
            ),
          );
          return;
        }

        final message = response["message"] ?? "Submitted successfully";
        final status = response["status"] ?? false;

        if (status == true) {
          AppLoggerHelper.logInfo(
            "Survey form submitted successfully: $message",
          );
          emit(AddSurveyOperativeFormSuccess(message: message, success: true));
        } else {
          AppLoggerHelper.logError("Survey form submission failed: $message");
          emit(AddSurveyOperativeFormError(message: message, success: false));
        }
      } catch (e) {
        AppLoggerHelper.logError("Exception in AddSurveyOperativeForm: $e");
        emit(
          AddSurveyOperativeFormError(message: e.toString(), success: false),
        );
      }
    });
  }
}
