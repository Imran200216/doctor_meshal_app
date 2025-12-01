part of 'subscribe_chat_message_bloc.dart';

abstract class SubscribeChatMessageEvent extends Equatable {
  const SubscribeChatMessageEvent();

  @override
  List<Object?> get props => [];
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
  List<Object?> get props => [senderRoomId, recieverRoomId, userId];
}

class StopSubscribeChatMessageEvent extends SubscribeChatMessageEvent {
  const StopSubscribeChatMessageEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
