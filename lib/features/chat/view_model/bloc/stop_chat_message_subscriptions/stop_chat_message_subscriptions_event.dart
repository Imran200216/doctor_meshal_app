part of 'stop_chat_message_subscriptions_bloc.dart';

sealed class StopChatMessageSubscriptionsEvent extends Equatable {
  const StopChatMessageSubscriptionsEvent();
}

final class StopChatMessageSubscription
    extends StopChatMessageSubscriptionsEvent {
  final String userId;

  const StopChatMessageSubscription({required this.userId});

  @override
  List<Object> get props => [userId];
}
