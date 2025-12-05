import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

part 'stop_chat_message_subscriptions_event.dart';

part 'stop_chat_message_subscriptions_state.dart';

class StopChatMessageSubscriptionsBloc
    extends
        Bloc<
          StopChatMessageSubscriptionsEvent,
          StopChatMessageSubscriptionsState
        > {
  final ChatGraphQLHttpService chatGraphQLHttpService;

  StopChatMessageSubscriptionsBloc({required this.chatGraphQLHttpService})
    : super(StopChatMessageSubscriptionsInitial()) {
    on<StopChatMessageSubscription>((event, emit) async {
      emit(StopChatMessageSubscriptionLoading());

      AppLoggerHelper.logInfo(
        "📩 StopChatMessageSubscription event triggered for userId: ${event.userId}",
      );

      try {
        String mutation =
            '''
          mutation Stop_chatmessage_subscriptions_ {
            stop_chatmessage_subscriptions_(user_id: "${event.userId}")
          }
        ''';

        AppLoggerHelper.logInfo("📡 Executing Mutation: $mutation");

        final result = await chatGraphQLHttpService.performMutation(mutation);

        AppLoggerHelper.logInfo("📨 Raw GraphQL Response: ${result.data}");

        if (result.data == null ||
            result.data!['stop_chatmessage_subscriptions_'] == null) {
          AppLoggerHelper.logError(
            "❌ GraphQL returned null or malformed response",
          );
          throw Exception("Failed to stop chat subscription.");
        }

        final isStopped =
            result.data!['stop_chatmessage_subscriptions_'] as bool;

        AppLoggerHelper.logInfo(
          "✅ stop_chatmessage_subscriptions_ result: $isStopped",
        );

        emit(
          StopChatMessageSubscriptionSuccess(
            stopChatMessageSubscription: isStopped,
          ),
        );

        AppLoggerHelper.logInfo(
          "🎉 StopChatMessageSubscriptionSuccess emitted",
        );
      } catch (e, stack) {
        AppLoggerHelper.logError("🔥 Error stopping chat subscription: $e");
        AppLoggerHelper.logError("📚 STACK TRACE: $stack");

        emit(StopChatMessageSubscriptionFailure(message: e.toString()));
      }
    });
  }
}
