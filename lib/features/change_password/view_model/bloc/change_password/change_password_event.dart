part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();
}

class ChangePasswordUserEvent extends ChangePasswordEvent {
  final String userId;
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordUserEvent(
    this.userId,
    this.oldPassword,
    this.newPassword,
    this.confirmPassword,
  );

  @override
  List<Object?> get props => [
    userId,
    oldPassword,
    newPassword,
    confirmPassword,
  ];
}
