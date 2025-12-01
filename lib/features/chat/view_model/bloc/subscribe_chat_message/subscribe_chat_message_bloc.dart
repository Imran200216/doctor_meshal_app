import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_message_model.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'subscribe_chat_message_event.dart';

part 'subscribe_chat_message_state.dart';

class SubscribeChatMessageBloc
    extends Bloc<SubscribeChatMessageEvent, SubscribeChatMessageState> {
  final ChatGraphQLHttpService chatGraphQLHttpService;

  // Subscription management
  StreamSubscription<QueryResult>? _messageSubscription;

  SubscribeChatMessageBloc({required this.chatGraphQLHttpService})
    : super(SubscribeChatMessageInitial()) {
    // Get All Chat Messages
    on<StartSubscribeChatMessageEvent>((event, emit) async {
      emit(GetSubscribeChatMessageLoading());

      try {
        String subscription =
            ''' 
         subscription Subscription {
  View_User_Chat_Message_(
    sender_room_id: "${event.senderRoomId}"
    reciever_room_id: "${event.recieverRoomId}"
    user_id: "${event.userId}"
  ) {
    chat_data_ {
      id
      message
      type
      status
      time
      image
    }
    is_receiver_online
    sender_room_id {
      user_id {
        first_name
        last_name
        profile_image
      }
    }
    reciever_room_id {
      id
      user_id {
        first_name
        id
        last_name
        profile_image
      }
    }
  }
}
   ''';

        AppLoggerHelper.logInfo("📡 GraphQL Subscription Query: $subscription");

        final stream = chatGraphQLHttpService.performSubscribe(subscription);

        await emit.forEach(
          stream,
          onData: (result) {
            if (result.hasException) {
              final errorState = GetSubscribeChatMessageError(
                message: "Subscription error: ${result.exception}",
              );
              emit(errorState);
              return errorState;
            }

            final data = result.data?['View_User_Chat_Message_'];

            if (data == null) {
              final errorState = GetSubscribeChatMessageError(
                message: "No chat data received from subscription",
              );
              emit(errorState);
              return errorState;
            }

            try {
              final chatData = ChatData.fromJson(data);
              final successState = GetSubscribeChatMessageSuccess(
                chatMessage: chatData,
              );

              emit(successState);
              return successState;
            } catch (e) {
              final errorState = GetSubscribeChatMessageError(
                message: "Failed to parse chat data: $e",
              );
              emit(errorState);
              return errorState;
            }
          },
          onError: (error, stackTrace) {
            final errorState = GetSubscribeChatMessageError(
              message: "Subscription connection error: $error",
            );
            emit(errorState);
            return errorState;
          },
        );
      } catch (e) {
        AppLoggerHelper.logError('💥 Bloc subscription error: $e');
        if (!emit.isDone) {
          emit(GetSubscribeChatMessageError(message: e.toString()));
        }
      }
    });

    on<StopSubscribeChatMessageEvent>((event, emit) {
      emit(SubscribeChatMessageInitial());
    });
  }
}
