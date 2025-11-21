import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_message_model.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'subscribe_chat_message_event.dart';

part 'subscribe_chat_message_state.dart';

class SubscribeChatMessageBloc
    extends Bloc<SubscribeChatMessageEvent, SubscribeChatMessageState> {
  final GraphQLService graphQLService;
  StreamSubscription<QueryResult>? _subscription;

  /// Track if subscription is already active
  bool _isSubscribed = false;

  SubscribeChatMessageBloc({required this.graphQLService})
    : super(SubscribeChatMessageInitial()) {
    on<StartSubscribeChatMessageEvent>(_onStartSubscription);
    on<StopSubcribeChatMessageEvent>(_onStopSubscription);
  }

  Future<void> _onStartSubscription(
    StartSubscribeChatMessageEvent event,
    Emitter<SubscribeChatMessageState> emit,
  ) async {
    if (_isSubscribed) {
      AppLoggerHelper.logInfo('Subscription already active, skipping...');
      return;
    }

    _isSubscribed = true;
    emit(GetSubscribeChatMessageLoading());
    AppLoggerHelper.logInfo('🔵 Starting chat subscription...');

    try {
      final subscriptionQuery =
          '''
        subscription View_User_Chat_Message_ {
          View_User_Chat_Message_(
            sender_room_id: "${event.senderRoomId}"
            reciever_room_id: "${event.recieverRoomId}"
            user_id: "${event.userId}"
          ) {
            is_receiver_online
            reciever_room_id {
              user_id {
                first_name
                last_name
                profile_image
              }
            }
            chat_data_ {
              id
              image
              message
              status
              time
              type
            }
          }
        }
      ''';

      _subscription = graphQLService.performSubscribe(subscriptionQuery).listen(
        (result) {
          if (result.hasException) {
            AppLoggerHelper.logError('Subscription error: ${result.exception}');
            emit(
              GetSubscribeChatMessageError(
                message: result.exception.toString(),
              ),
            );
            return;
          }

          final data = result.data?['View_User_Chat_Message_'];
          if (data == null) {
            AppLoggerHelper.logWarning('Subscription returned null data');
            return;
          }

          final chatData = ChatData.fromJson(data);

          // Log each message for debugging
          for (var msg in chatData.messages) {
            AppLoggerHelper.logInfo(
              'Message from subscription: ${msg.message} | type: ${msg.type}',
            );
          }

          emit(GetSubscribeChatMessageSuccess(chatMessage: chatData));
        },
      );
    } catch (e) {
      AppLoggerHelper.logError('Failed to start subscription: $e');
      emit(GetSubscribeChatMessageError(message: e.toString()));
    }
  }

  Future<void> _onStopSubscription(
    StopSubcribeChatMessageEvent event,
    Emitter<SubscribeChatMessageState> emit,
  ) async {
    if (!_isSubscribed) return;

    AppLoggerHelper.logInfo('Stopping chat subscription...');
    await _subscription?.cancel();
    _subscription = null;
    _isSubscribed = false;
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    _isSubscribed = false;
    return super.close();
  }
}
