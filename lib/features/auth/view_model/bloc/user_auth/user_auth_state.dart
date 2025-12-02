part of 'user_auth_bloc.dart';

sealed class UserAuthState extends Equatable {
  const UserAuthState();
}

final class UserAuthInitial extends UserAuthState {
  @override
  List<Object> get props => [];
}

final class GetUserAuthLoading extends UserAuthState {
  @override
  List<Object> get props => [];
}

final class GetUserAuthSuccess extends UserAuthState {
  final UserAuthModel user;

  const GetUserAuthSuccess({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

final class GetUserAuthFailure extends UserAuthState {
  final String message;

  const GetUserAuthFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
