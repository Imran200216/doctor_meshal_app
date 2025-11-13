import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final GraphQLService graphQLService;

  ChangePasswordBloc({required this.graphQLService})
    : super(ChangePasswordInitial()) {
    // 🔹 Change Password User Event
    on<ChangePasswordUserEvent>((event, emit) async {
      emit(ChangePasswordLoading());

      try {
        final String mutation =
            '''
          mutation {
            change_patient_user_password_(
              user_id_: "${event.userId}"
              old_password: "${event.oldPassword}"
              new_password: "${event.newPassword}"
              confirm_password: "${event.confirmPassword}"
            ) {
              message
              success
            }
          }
        ''';

        AppLoggerHelper.logInfo(
          "🔹 Running change_patient_user_password_ mutation...",
        );
        final result = await graphQLService.performMutation(mutation);

        final data = result.data?['change_patient_user_password_'];
        AppLoggerHelper.logInfo("✅ GraphQL Response: $data");

        if (data != null && data['success'] == true) {
          emit(
            ChangePasswordSuccess(
              message: data['message'] ?? "Password changed successfully",
              success: data['success'],
            ),
          );
          AppLoggerHelper.logInfo(
            "🎉 Password change successful: ${data['message']}",
          );
        } else {
          emit(
            ChangePasswordFailure(
              message: data?['message'] ?? "Password change failed",
            ),
          );
          AppLoggerHelper.logError(
            "⚠️ Password change failed: ${data?['message']}",
          );
        }
      } catch (e) {
        AppLoggerHelper.logError("❌ Error while changing password: $e");
        emit(ChangePasswordFailure(message: e.toString()));
      }
    });
  }
}
