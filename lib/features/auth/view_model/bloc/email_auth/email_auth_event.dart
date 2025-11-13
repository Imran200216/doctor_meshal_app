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
