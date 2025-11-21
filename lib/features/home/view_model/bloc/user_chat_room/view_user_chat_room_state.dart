part of 'view_user_chat_room_bloc.dart';

sealed class ViewUserChatRoomState extends Equatable {
  const ViewUserChatRoomState();
}

final class ViewUserChatRoomInitial extends ViewUserChatRoomState {
  @override
  List<Object> get props => [];
}

final class GetViewUserChatRoomLoading extends ViewUserChatRoomState {
  @override
  List<Object> get props => [];
}

final class GetViewUserChatRoomSuccess extends ViewUserChatRoomState {
  final String id;
  final String notificationCount;

  const GetViewUserChatRoomSuccess({
    required this.id,
    required this.notificationCount,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, notificationCount];
}

final class GetViewUserChatRoomFailure extends ViewUserChatRoomState {
  final String message;

  const GetViewUserChatRoomFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
