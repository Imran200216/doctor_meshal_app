part of 'view_user_chat_room_bloc.dart';

sealed class ViewUserChatRoomEvent extends Equatable {
  const ViewUserChatRoomEvent();
}

class GetViewChatRoomEvent extends ViewUserChatRoomEvent {
  final String userId;

  const GetViewChatRoomEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
