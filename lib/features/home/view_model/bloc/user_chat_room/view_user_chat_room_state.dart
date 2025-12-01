part of 'view_user_chat_room_bloc.dart';

sealed class ViewUserChatRoomState extends Equatable {
  const ViewUserChatRoomState();
}

final class ViewUserChatRoomInitial extends ViewUserChatRoomState {
  @override
  List<Object> get props => [];
}

final class GetViewUserHomeChatRoomLoading extends ViewUserChatRoomState {
  @override
  List<Object> get props => [];
}

final class GetViewUserHomeChatRoomSuccess extends ViewUserChatRoomState {
  final String id;
  final String notificationCount;

  const GetViewUserHomeChatRoomSuccess({
    required this.id,
    required this.notificationCount,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, notificationCount];
}

final class GetViewUserHomeChatRoomFailure extends ViewUserChatRoomState {
  final String message;

  const GetViewUserHomeChatRoomFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
