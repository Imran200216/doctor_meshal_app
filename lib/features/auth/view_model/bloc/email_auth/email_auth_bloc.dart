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
          emit(EmailAuthError("Login Failed!"));
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

    // Email Auth Forget Password Event
    on<EmailAuthForgotPasswordEvent>((event, emit) async {
      emit(EmailAuthForgetPasswordLoading());

      try {
        String query =
            '''
       query Send_email_verification_for_forgot_user_password_ {
  send_email_verification_for_forgot_user_password_(
    email: "${event.email}"
  ) {
    message
    success
    token
  }
}

        ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        // Access the data safely
        final forgetPasswordData =
            result.data?["send_email_verification_for_forgot_user_password_"];
        AppLoggerHelper.logInfo("GraphQL Response Data: $forgetPasswordData");

        if (forgetPasswordData == null) {
          AppLoggerHelper.logError(
            "No data returned from server for email: ${event.email}",
          );
          emit(
            EmailAuthForgetPasswordFailure(
              message: "Please enter valid Email Address",
            ),
          );
          return;
        }

        emit(
          EmailAuthForgetPasswordSuccess(
            message: forgetPasswordData['message'],
            success: forgetPasswordData['success'],
            token: forgetPasswordData['token'],
          ),
        );

        AppLoggerHelper.logInfo(
          "Email login successful for email: ${event.email}",
        );
      } catch (e) {
        emit(EmailAuthForgetPasswordFailure(message: e.toString()));
      }
    });

    // Email Auth OTP Verification Event
    on<EmailAuthVerifyOTPEvent>((event, emit) async {
      emit(EmailAuthOTPVerificationLoading());

      try {
        String query =
            ''' 
        query Verification_OTP_Forgotpassword_Emailveriy_ {
  Verification_OTP_Forgotpassword_Emailveriy_(
    email: "${event.email}"
    otp_: "${event.otp}"
    token: "${event.token}"
  ) {
    message
    status
  }
}

         ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        // Access the data safely
        final verifyOTPForgetPasswordData =
            result.data?["Verification_OTP_Forgotpassword_Emailveriy_"];
        AppLoggerHelper.logInfo(
          "GraphQL Response Data: $verifyOTPForgetPasswordData",
        );

        if (verifyOTPForgetPasswordData == null) {
          AppLoggerHelper.logError(
            "No data returned from server for email: ${event.email}",
          );
          emit(
            EmailAuthOTPVerificationFailure(
              message: "Please Enter Valid OTP",
              status: false,
            ),
          );
          return;
        }

        emit(
          EmailAuthOTPVerificationSuccess(
            message: verifyOTPForgetPasswordData['message'],
            status: verifyOTPForgetPasswordData['status'] == true,
          ),
        );

        AppLoggerHelper.logInfo(
          "Email otp verification successful for email: ${event.email}",
        );
      } catch (e) {
        emit(
          EmailAuthOTPVerificationFailure(message: e.toString(), status: false),
        );
      }
    });

    // Email Auth Change Password Event
    on<EmailAuthChangePasswordEvent>((event, emit) async {
      emit(EmailAuthChangePasswordLoading());

      try {
        String query =
            ''' 
        query Reset_User_Password_forgot_password {
  Reset_User_Password_forgot_password(
    email: "${event.email}"
    newpassword: "${event.newPassword}"
    confirm_password: "${event.confirmPassword}"
  ) {
    message
    status
  }
}
   ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        // Access the data safely
        final resetUserForgetPasswordData =
            result.data?["Reset_User_Password_forgot_password"];
        AppLoggerHelper.logInfo(
          "GraphQL Response Data: $resetUserForgetPasswordData",
        );

        if (resetUserForgetPasswordData == null) {
          AppLoggerHelper.logError(
            "No data returned from server for email: ${event.email}",
          );
          emit(
            EmailAuthChangePasswordFailure(
              message: "Please Enter Valid OTP",
              status: resetUserForgetPasswordData['status'] == false,
            ),
          );
          return;
        }

        emit(
          EmailAuthChangePasswordSuccess(
            message: resetUserForgetPasswordData['message'],
            status: resetUserForgetPasswordData['status'] == true,
          ),
        );

        AppLoggerHelper.logInfo(
          "Email otp verification successful for email: ${event.email}",
        );
      } catch (e) {
        emit(
          EmailAuthChangePasswordFailure(message: e.toString(), status: false),
        );
      }
    });

    // Email Auth OTP Resend Event
    on<EmailAuthOTPResendEvent>((event, emit) async {
      emit(EmailAuthResendOTPLoading());

      try {
        String query =
            ''' 
      query Resend_OTP_for_Email_Verification_forgotpassword_ {
        Resend_OTP_for_Email_Verification_forgotpassword_(
          email: "${event.email}"
        ) {
          message
          success
          token
        }
      }
    ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await graphQLService.performQuery(query);

        // Access the data safely
        final resendOTPData =
            result.data?["Resend_OTP_for_Email_Verification_forgotpassword_"];

        AppLoggerHelper.logInfo("GraphQL Response Data: $resendOTPData");

        // Check if data is null or if the operation failed
        if (resendOTPData == null) {
          AppLoggerHelper.logError(
            "No data returned from server for email: ${event.email}",
          );
          emit(
            EmailAuthResendOTPFailure(
              message: "No response from server",
              success: false,
            ),
          );
          return;
        }

        // Check if the operation was successful
        if (resendOTPData['success'] == true) {
          emit(
            EmailAuthResendOTPSuccess(
              message: resendOTPData['message'],
              success: true,
              token: resendOTPData['token'],
            ),
          );
          AppLoggerHelper.logInfo(
            "Email OTP resend successful for email: ${event.email}",
          );
        } else {
          // API returned success: false
          emit(
            EmailAuthResendOTPFailure(
              message: resendOTPData['message'] ?? "Failed to resend OTP",
              success: false,
            ),
          );
        }
      } catch (e) {
        AppLoggerHelper.logError("Error resending OTP: $e");
        emit(
          EmailAuthResendOTPFailure(
            message: "An error occurred: ${e.toString()}",
            success: false,
          ),
        );
      }
    });

    // Email Auth Logout Event
    on<EmailAuthLogoutEvent>((event, emit) async {
      emit(EmailAuthLogoutLoading());

      try {
        String query =
            ''' 
        
        query Log_out_user_ {
  log_out_user_(user_id: "${event.userId}") {
    message
    status
  }
}
          ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");


        final result = await graphQLService.performQuery(query);

        // Access the data safely
        final logOutUser = result.data?["log_out_user_"];

        AppLoggerHelper.logInfo("GraphQL Response Data: $logOutUser");

        // Check if data is null or if the operation failed
        if (logOutUser == null) {
          AppLoggerHelper.logError(
            "No data returned from server for email: ${event.userId}",
          );
          emit(
            EmailAuthLogoutFailure(
              message: "No response from server",
              status: false,
            ),
          );
          return;
        }

        // Check if the operation was successful
        if (logOutUser['status'] == true) {
          emit(
            EmailAuthLogoutSuccess(
              message: logOutUser['message'],
              status: logOutUser['status'] == true,
            ),
          );
        } else {
          // API returned success: false
          emit(
            EmailAuthLogoutFailure(
              message: logOutUser['message'] ?? "Failed to Logout",
              status: false,
            ),
          );
        }
      } catch (e) {
        emit(EmailAuthLogoutFailure(message: e.toString(), status: false));
      }
    });
  }
}
