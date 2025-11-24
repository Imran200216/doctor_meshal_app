part of 'send_chat_message_bloc.dart';

sealed class SendChatMessageState extends Equatable {
  const SendChatMessageState();
}

final class SendChatMessageInitial extends SendChatMessageState {
  @override
  List<Object> get props => [];
}

final class SendChatMessageFuncLoading extends SendChatMessageState {
  @override
  List<Object> get props => [];
}

final class SendChatMessageFuncSuccess extends SendChatMessageState {
  final String message;

  const SendChatMessageFuncSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class SendChatMessageFuncFailure extends SendChatMessageState {
  final String message;

  const SendChatMessageFuncFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
