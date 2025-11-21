part of 'email_auth_bloc.dart';

sealed class EmailAuthState extends Equatable {
  const EmailAuthState();
}

final class EmailAuthInitial extends EmailAuthState {
  @override
  List<Object> get props => [];
}

// Email Auth Login & Register
final class EmailAuthLoading extends EmailAuthState {
  @override
  List<Object> get props => [];
}

class EmailAuthSuccess extends EmailAuthState {
  final String id;
  final String message;
  final bool success;
  final String token;

  const EmailAuthSuccess({
    required this.id,
    required this.message,

    required this.success,
    required this.token,
  });

  @override
  List<Object?> get props => [id, message, success, token];
}

final class EmailAuthError extends EmailAuthState {
  final String message;

  const EmailAuthError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

// Email Auth Forget Password
final class EmailAuthForgetPasswordLoading extends EmailAuthState {
  @override
  List<Object> get props => [];
}

// Email Auth Forget Password Success
class EmailAuthForgetPasswordSuccess extends EmailAuthState {
  final String message;
  final bool success;
  final String token;

  const EmailAuthForgetPasswordSuccess({
    required this.message,
    required this.success,
    required this.token,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, token, success];
}

class EmailAuthForgetPasswordFailure extends EmailAuthState {
  final String message;

  const EmailAuthForgetPasswordFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

// Email Auth Forget Password
final class EmailAuthOTPVerificationLoading extends EmailAuthState {
  @override
  List<Object> get props => [];
}

// Email Auth Forget Password Success
class EmailAuthOTPVerificationSuccess extends EmailAuthState {
  final String message;
  final bool status;

  const EmailAuthOTPVerificationSuccess({
    required this.message,
    required this.status,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class EmailAuthOTPVerificationFailure extends EmailAuthState {
  final String message;
  final bool status;

  const EmailAuthOTPVerificationFailure({
    required this.message,
    required this.status,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, status];
}

// Email Auth Change Password Loading
final class EmailAuthChangePasswordLoading extends EmailAuthState {
  @override
  List<Object> get props => [];
}

// Email Auth Change Password Success
class EmailAuthChangePasswordSuccess extends EmailAuthState {
  final String message;
  final bool status;

  const EmailAuthChangePasswordSuccess({
    required this.message,
    required this.status,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

// Email Auth Change Password Failure
class EmailAuthChangePasswordFailure extends EmailAuthState {
  final String message;
  final bool status;

  const EmailAuthChangePasswordFailure({
    required this.message,
    required this.status,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, status];
}

// Email Auth Resend OTP Loading
final class EmailAuthResendOTPLoading extends EmailAuthState {
  @override
  List<Object> get props => [];
}

// Email Auth Resend OTP Success
class EmailAuthResendOTPSuccess extends EmailAuthState {
  final String message;
  final bool success;
  final String token;

  const EmailAuthResendOTPSuccess({
    required this.message,
    required this.success,
    required this.token,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, success, token];
}

// Email Auth Resend OTP Failure
class EmailAuthResendOTPFailure extends EmailAuthState {
  final String message;
  final bool success;

  const EmailAuthResendOTPFailure({
    required this.message,
    required this.success,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [message, success];
}

// Email Auth Logout Loading
class EmailAuthLogoutLoading extends EmailAuthState {
  @override
  List<Object> get props => [];
}

// Email Auth Logout Success
class EmailAuthLogoutSuccess extends EmailAuthState {
  final String message;
  final bool status;

  const EmailAuthLogoutSuccess({required this.message, required this.status});

  @override
  // TODO: implement props
  List<Object?> get props => [message, status];
}

// Email Auth Logout Failure
class EmailAuthLogoutFailure extends EmailAuthState {
  final String message;
  final bool status;

  const EmailAuthLogoutFailure({required this.message, required this.status});

  @override
  // TODO: implement props
  List<Object?> get props => [message, status];
}
