part of 'user_auth_bloc.dart';

sealed class UserAuthEvent extends Equatable {
  const UserAuthEvent();
}

final class GetUserAuthEvent extends UserAuthEvent {
  final String id;
  final String token;

  const GetUserAuthEvent({required this.id, required this.token});

  @override
  // TODO: implement props
  List<Object?> get props => [id, token];
}
