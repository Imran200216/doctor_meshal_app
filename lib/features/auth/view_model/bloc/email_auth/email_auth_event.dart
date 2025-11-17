part of 'email_auth_bloc.dart';

sealed class EmailAuthEvent extends Equatable {
  const EmailAuthEvent();
}

class EmailAuthLoginEvent extends EmailAuthEvent {
  final String email;
  final String password;
  final String? phoneCode;
  final String? phoneNumber;
  final String? fcmToken;

  const EmailAuthLoginEvent({
    required this.email,
    required this.password,
    this.phoneCode,
    this.phoneNumber,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    phoneCode,
    phoneNumber,
    fcmToken,
  ];
}

// Logout Event
final class EmailAuthLogoutEvent extends EmailAuthEvent {
  const EmailAuthLogoutEvent();

  @override
  List<Object?> get props => [];
}

// Register Event
class EmailAuthRegisterEvent extends EmailAuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneCode;
  final String phoneNumber;

  const EmailAuthRegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneCode,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    phoneCode,
    phoneNumber,
  ];
}

// Forgot Password
class EmailAuthForgotPasswordEvent extends EmailAuthEvent {
  final String email;

  const EmailAuthForgotPasswordEvent({required this.email});

  @override
  // TODO: implement props
  List<Object?> get props => [email];
}

// Verification OTP Forget Password Verify Event
class EmailAuthVerifyOTPEvent extends EmailAuthEvent {
  final String email;
  final String otp;
  final String token;

  const EmailAuthVerifyOTPEvent({
    required this.email,
    required this.otp,
    required this.token,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [email, otp, token];
}

// Email Auth Change Password Event
class EmailAuthChangePasswordEvent extends EmailAuthEvent {
  final String email;
  final String newPassword;
  final String confirmPassword;

  const EmailAuthChangePasswordEvent({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [email, confirmPassword, newPassword];
}

// Email Auth OTP Resend Event
class EmailAuthOTPResendEvent extends EmailAuthEvent {
  final String email;

  const EmailAuthOTPResendEvent({required this.email});

  @override
  // TODO: implement props
  List<Object?> get props => [email];
}
