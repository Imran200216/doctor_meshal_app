part of 'send_chat_message_bloc.dart';

sealed class SendChatMessageEvent extends Equatable {
  const SendChatMessageEvent();
}

final class SendChatMessageFuncEvent extends SendChatMessageEvent {
  final String senderRoomId;
  final String receiverRoomId;
  final String message;

  const SendChatMessageFuncEvent({
    required this.senderRoomId,
    required this.receiverRoomId,
    required this.message,
  });

  @override
  List<Object> get props => [senderRoomId, receiverRoomId, message];
}
