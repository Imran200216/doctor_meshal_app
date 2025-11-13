part of 'change_password_bloc.dart';

sealed class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

final class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

final class ChangePasswordLoading extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

final class ChangePasswordSuccess extends ChangePasswordState {
  final String message;
  final bool success;

  const ChangePasswordSuccess({required this.message, required this.success});

  @override
  List<Object> get props => [message, success];
}

final class ChangePasswordFailure extends ChangePasswordState {
  final String message;

  const ChangePasswordFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
