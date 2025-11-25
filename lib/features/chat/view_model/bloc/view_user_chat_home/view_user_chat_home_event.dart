part of 'view_user_chat_home_bloc.dart';

sealed class ViewUserChatHomeEvent extends Equatable {
  const ViewUserChatHomeEvent();

  @override
  List<Object> get props => [];
}

final class GetViewUserChatHomeEvent extends ViewUserChatHomeEvent {
  final String userId;

  const GetViewUserChatHomeEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

// Add these missing event classes:
final class StopViewUserChatHomeSubscriptionEvent
    extends ViewUserChatHomeEvent {
  const StopViewUserChatHomeSubscriptionEvent();

  @override
  List<Object> get props => [];
}

final class ReconnectHomeSubscriptionEvent extends ViewUserChatHomeEvent {
  const ReconnectHomeSubscriptionEvent();

  @override
  List<Object> get props => [];
}

class GetViewUserChatRoomEvent extends ViewUserChatHomeEvent {
  final String userId;

  const GetViewUserChatRoomEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
