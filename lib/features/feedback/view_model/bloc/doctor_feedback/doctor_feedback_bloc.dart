import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/feedback/feedback.dart';

part 'doctor_feedback_event.dart';

part 'doctor_feedback_state.dart';

class DoctorFeedbackBloc
    extends Bloc<DoctorFeedbackEvent, DoctorFeedbackState> {
  final GraphQLService graphQLService;

  DoctorFeedbackBloc({required this.graphQLService})
    : super(DoctorFeedbackInitial()) {
    // Write Doctor Feedback Event
    on<WriteDoctorFeedbackEvent>((event, emit) async {
      emit(WriteDoctorFeedbackLoading());

      try {
        AppLoggerHelper.logInfo(
          "📤 Sending feedback for user: ${event.userId}",
        );

        String mutation =
            '''
        mutation Submit_patient_feed_back_for_doctor_ {
          submit_patient_feed_back_for_doctor_(
            feed_back: "${event.feedBack}",
            user_id: "${event.userId}"
          )
        }
        ''';

        final result = await graphQLService.performMutation(mutation);

        /// Check GraphQL errors
        if (result.hasException) {
          AppLoggerHelper.logError(
            "❌ GraphQL Error: ${result.exception.toString()}",
          );

          emit(
            WriteDoctorFeedbackFailure(
              message: "Something went wrong. Please try again.",
            ),
          );
          return;
        }

        /// API returns STRING, not boolean ❗
        final response =
            result.data?["submit_patient_feed_back_for_doctor_"] as String?;

        if (response == null || response.isEmpty) {
          AppLoggerHelper.logError(
            "❌ Feedback API returned null or empty response.",
          );

          emit(
            WriteDoctorFeedbackFailure(message: "Failed to submit feedback."),
          );
          return;
        }

        /// SUCCESS
        AppLoggerHelper.logInfo("✅ Feedback submitted successfully: $response");

        emit(WriteDoctorFeedbackSuccess(message: response));
      } catch (e, stackTrace) {
        AppLoggerHelper.logError(
          "❌ Unexpected Error: $e\nStackTrace: $stackTrace",
        );

        emit(
          WriteDoctorFeedbackFailure(
            message: "Unexpected error. Please try again.",
          ),
        );
      }
    });

    // Get Doctor Patient Feedbacks Event
    on<GetDoctorPatientFeedbacksEvent>((event, emit) async {
      emit(GetPatientFeedbacksLoading());

      try {
        final query =
            '''
      query View_all_patient_feedback_ {
        view_all_patient_feedback_(user_id: "${event.userId}") {
          feed_back
          id
          createdAt
          patient_id {
            id
            last_name
            profile_image
            first_name
          }
        }
      }
    ''';

        AppLoggerHelper.logInfo("Feedback Query: $query");

        final result = await graphQLService.performQuery(query);

        AppLoggerHelper.logInfo("GraphQL Raw Result: ${result.data}");

        // Extract JSON using result.data
        final List<dynamic> dataList =
            result.data?['view_all_patient_feedback_'] ?? [];

        AppLoggerHelper.logInfo("Parsed Feedback Count: ${dataList.length}");

        // Convert JSON → Model list
        final feedbackList = dataList
            .map((e) => FeedbackModel.fromJson(e))
            .toList();

        emit(GetPatientFeedbacksSuccess(feedbacks: feedbackList));
      } catch (e) {
        AppLoggerHelper.logError("Feedback Fetch Error: $e");
        emit(GetPatientFeedbacksFailure(message: e.toString()));
      }
    });
  }
}
