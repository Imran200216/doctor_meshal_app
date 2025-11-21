part of 'view_user_chat_room_message_bloc.dart';

sealed class ViewUserChatRoomMessageEvent extends Equatable {
  const ViewUserChatRoomMessageEvent();
}

class GetViewUserChatRoomMessageEvent extends ViewUserChatRoomMessageEvent {
  final String senderRoomId;
  final String recieverRoomId;
  final String userId;

  const GetViewUserChatRoomMessageEvent({
    required this.senderRoomId,
    required this.recieverRoomId,
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [senderRoomId, recieverRoomId, userId];
}
