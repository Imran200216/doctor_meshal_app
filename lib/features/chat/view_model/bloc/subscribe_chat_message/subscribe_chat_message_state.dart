part of 'subscribe_chat_message_bloc.dart';

sealed class SubscribeChatMessageState extends Equatable {
  const SubscribeChatMessageState();
}

final class SubscribeChatMessageInitial extends SubscribeChatMessageState {
  @override
  List<Object> get props => [];
}

final class GetSubscribeChatMessageLoading extends SubscribeChatMessageState {
  @override
  List<Object> get props => [];
}

final class GetSubscribeChatMessageSuccess extends SubscribeChatMessageState {
  final ChatData chatMessage;

  const GetSubscribeChatMessageSuccess({required this.chatMessage});

  @override
  // TODO: implement props
  List<Object> get props => [chatMessage];
}

final class GetSubscribeChatMessageError extends SubscribeChatMessageState {
  final String message;

  const GetSubscribeChatMessageError({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
