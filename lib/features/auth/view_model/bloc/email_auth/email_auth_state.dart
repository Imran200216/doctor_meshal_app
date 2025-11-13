part of 'email_auth_bloc.dart';

sealed class EmailAuthState extends Equatable {
  const EmailAuthState();
}

final class EmailAuthInitial extends EmailAuthState {
  @override
  List<Object> get props => [];
}

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
