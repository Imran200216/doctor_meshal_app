import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'email_auth_event.dart';

part 'email_auth_state.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  final GraphQLService graphQLService;

  EmailAuthBloc(this.graphQLService) : super(EmailAuthInitial()) {
    // Email Auth Login Event
    on<EmailAuthLoginEvent>((event, emit) async {
      emit(EmailAuthLoading());

      try {
        String query =
            '''
        query Login_user_ {
          login_user_(
            email: "${event.email}"
            phone_code: "${event.phoneCode}"
            phone_number: "${event.phoneNumber}"
            password: "${event.password}"
            fcm_token: "${event.fcmToken}"
          ) {
            id
            message
            success
            token
          }
        }
        ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        // Access the data safely
        final loginData = result.data?['login_user_'];
        AppLoggerHelper.logInfo("GraphQL Response Data: $loginData");

        if (loginData == null) {
          AppLoggerHelper.logError(
            "No data returned from server for email: ${event.email}",
          );
          emit(EmailAuthError("No data returned from server"));
          return;
        }

        emit(
          EmailAuthSuccess(
            id: loginData['id'],
            message: loginData['message'],
            success: loginData['success'],
            token: loginData['token'],
          ),
        );

        AppLoggerHelper.logInfo(
          "Email login successful for email: ${event.email}",
        );
      } catch (e) {
        AppLoggerHelper.logError(
          "Email login error for email: ${event.email}, Error: $e",
        );
        emit(EmailAuthError(e.toString()));
      }
    });

    // Email Auth Register Event

    on<EmailAuthRegisterEvent>((event, emit) async {
      emit(EmailAuthLoading());

      try {
        final mutation =
            '''
      mutation {
        Register_user_(
          first_name: "${event.firstName}"
          last_name: "${event.lastName}"
          email: "${event.email}"
          phone_code: "${event.phoneCode}"
          phone_number: "${event.phoneNumber}"
          password: "${event.password}"
        ) {
          id
          message
          success
          token
        }
      }
    ''';

        AppLoggerHelper.logInfo("📡 Running Register_user_ mutation...");
        final result = await graphQLService.performMutation(mutation);

        final data = result.data?['Register_user_'];
        AppLoggerHelper.logInfo("✅ GraphQL Response: $data");

        if (data != null && data['success'] == true) {
          emit(
            EmailAuthSuccess(
              message: data['message'],
              token: data['token'],
              id: data['id'],
              success: data['success'],
            ),
          );
          AppLoggerHelper.logInfo(
            "🎉 Registration Success: ${data['message']}",
          );
        } else {
          emit(EmailAuthError(data?['message'] ?? 'Registration failed'));
          AppLoggerHelper.logError(
            "⚠️ Registration Failed: ${data?['message']}",
          );
        }
      } catch (e) {
        emit(EmailAuthError(e.toString()));
        AppLoggerHelper.logError("❌ Registration Error: $e");
      }
    });
  }
}
