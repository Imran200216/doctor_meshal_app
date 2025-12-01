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

// In view_user_chat_home_event.dart
final class ResetViewUserChatHomeStateEvent extends ViewUserChatHomeEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
