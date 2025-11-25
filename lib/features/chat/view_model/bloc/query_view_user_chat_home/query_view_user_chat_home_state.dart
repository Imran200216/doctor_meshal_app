part of 'query_view_user_chat_home_bloc.dart';

sealed class QueryViewUserChatHomeState extends Equatable {
  const QueryViewUserChatHomeState();
}

final class QueryViewUserChatHomeInitial extends QueryViewUserChatHomeState {
  @override
  List<Object> get props => [];
}

final class GetQueryViewUserChatHomeLoading extends QueryViewUserChatHomeState {
  @override
  List<Object> get props => [];
}

final class GetQueryViewUserChatHomeSuccess extends QueryViewUserChatHomeState {
  final String id;
  final String notificationCount;

  const GetQueryViewUserChatHomeSuccess({required this.id, required this.notificationCount});

  @override
  // TODO: implement props
  List<Object?> get props => [id, notificationCount];
}

final class GetQueryViewUserChatHomeFailure extends QueryViewUserChatHomeState {
  final String message;

  const GetQueryViewUserChatHomeFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
