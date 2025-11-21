part of 'view_user_chat_room_message_bloc.dart';

sealed class ViewUserChatRoomMessageState extends Equatable {
  const ViewUserChatRoomMessageState();
}

final class ViewUserChatRoomMessageInitial
    extends ViewUserChatRoomMessageState {
  @override
  List<Object> get props => [];
}

final class GetViewUserChatRoomMessageLoading
    extends ViewUserChatRoomMessageState {
  @override
  List<Object> get props => [];
}

final class GetViewUserChatRoomMessageSuccess
    extends ViewUserChatRoomMessageState {
  final ChatData chatMessage;

  const GetViewUserChatRoomMessageSuccess({
    required this.chatMessage,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [chatMessage];
}

final class GetViewUserChatRoomMessageFailure
    extends ViewUserChatRoomMessageState {
  final String message;

  const GetViewUserChatRoomMessageFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
