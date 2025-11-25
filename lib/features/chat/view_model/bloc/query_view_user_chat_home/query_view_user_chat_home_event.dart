part of 'query_view_user_chat_home_bloc.dart';

sealed class QueryViewUserChatHomeEvent extends Equatable {
  const QueryViewUserChatHomeEvent();
}

final class GetQueryViewUserChatHomeEvent extends QueryViewUserChatHomeEvent {
  final String userId;

  const GetQueryViewUserChatHomeEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
