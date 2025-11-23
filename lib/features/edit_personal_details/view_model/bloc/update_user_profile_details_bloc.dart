import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/edit_personal_details/model/update_user_profile_details_model.dart';

part 'update_user_profile_details_event.dart';

part 'update_user_profile_details_state.dart';

class UpdateUserProfileDetailsBloc
    extends Bloc<UpdateUserProfileDetailsEvent, UpdateUserProfileDetailsState> {
  final GraphQLService graphQLService;

  UpdateUserProfileDetailsBloc({required this.graphQLService})
    : super(UpdateUserProfileDetailsInitial()) {
    // Update User Profile Details Form Event
    on<UpdateUserProfileDetailsFormEvent>((event, emit) async {
      emit(UpdateUserProfileDetailsLoading());

      try {
        AppLoggerHelper.logInfo(
          "🔵 Preparing GraphQL mutation for update profile...",
        );

        // Build mutation
        final String mutation =
            '''
    mutation Update_user_profile_detail_ {
      update_user_profile_detail_(
        first_name_: "${event.model.fistName}"
        last_name_: "${event.model.lastName}"
        age_: "${event.model.age}"
        gender_: "${event.model.gender}"
        height_: "${event.model.height}"
        weight_: "${event.model.weight}"
        blood_group_: "${event.model.bloodGroup}"
        user_id_: "${event.model.userId}"
        profile_image_: "${event.model.profileImage}"
      )
    }
    ''';

        // Log mutation safely
        AppLoggerHelper.logInfo("🟦 GraphQL Mutation:\n$mutation");

        // Execute mutation
        AppLoggerHelper.logInfo("🟨 Executing GraphQL mutation...");
        final result = await graphQLService.performMutation(mutation);

        // Log result response
        AppLoggerHelper.logInfo("🟩 GraphQL Raw Result: ${result.data}");

        // Check for error
        if (result.hasException) {
          AppLoggerHelper.logError(
            "❌ GraphQL Exception: ${result.exception.toString()}",
          );

          emit(
            UpdateUserProfileDetailsFailure(
              message: result.exception.toString(),
            ),
          );
          return;
        }

        // Extract data
        final data = result.data?['update_user_profile_detail_'];

        AppLoggerHelper.logInfo("🟦 Extracted data from response: $data");

        if (data != null) {
          AppLoggerHelper.logInfo(
            "✅ Profile Updated Successfully! Response: $data",
          );

          emit(UpdateUserProfileDetailsSuccess(message: data.toString()));
        } else {
          AppLoggerHelper.logWarning(
            "⚠️ update_user_profile_detail_ returned NULL value!",
          );

          emit(
            const UpdateUserProfileDetailsFailure(
              message: "Failed to update user profile",
            ),
          );
        }
      } catch (e) {
        AppLoggerHelper.logError("🔥 Catch Error: ${e.toString()}");

        emit(
          UpdateUserProfileDetailsFailure(message: "Error: ${e.toString()}"),
        );
      }
    });
  }
}
