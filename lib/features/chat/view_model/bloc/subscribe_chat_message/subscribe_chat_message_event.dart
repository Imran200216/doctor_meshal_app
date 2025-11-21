part of 'subscribe_chat_message_bloc.dart';

sealed class SubscribeChatMessageEvent extends Equatable {
  const SubscribeChatMessageEvent();
}

class StartSubscribeChatMessageEvent extends SubscribeChatMessageEvent {
  final String senderRoomId;
  final String recieverRoomId;
  final String userId;

  const StartSubscribeChatMessageEvent({
    required this.senderRoomId,
    required this.recieverRoomId,
    required this.userId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [senderRoomId,recieverRoomId, userId];
}

class StopSubcribeChatMessageEvent extends SubscribeChatMessageEvent {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

