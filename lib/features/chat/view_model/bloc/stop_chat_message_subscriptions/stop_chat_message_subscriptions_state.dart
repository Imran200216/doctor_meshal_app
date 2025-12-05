part of 'stop_chat_message_subscriptions_bloc.dart';

sealed class StopChatMessageSubscriptionsState extends Equatable {
  const StopChatMessageSubscriptionsState();
}

final class StopChatMessageSubscriptionsInitial
    extends StopChatMessageSubscriptionsState {
  @override
  List<Object> get props => [];
}

final class StopChatMessageSubscriptionLoading
    extends StopChatMessageSubscriptionsState {
  @override
  List<Object> get props => [];
}

final class StopChatMessageSubscriptionSuccess
    extends StopChatMessageSubscriptionsState {
  final bool stopChatMessageSubscription;

  const StopChatMessageSubscriptionSuccess({
    required this.stopChatMessageSubscription,
  });

  @override
  List<Object> get props => [stopChatMessageSubscription];
}

final class StopChatMessageSubscriptionFailure
    extends StopChatMessageSubscriptionsState {
  final String message;

  const StopChatMessageSubscriptionFailure({required this.message});

  @override
  List<Object> get props => [message];
}
