import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_message_model.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'subscribe_chat_message_event.dart';

part 'subscribe_chat_message_state.dart';

class SubscribeChatMessageBloc
    extends Bloc<SubscribeChatMessageEvent, SubscribeChatMessageState> {
  final ChatGraphQLHttpService chatGraphQLHttpService;

  // Subscription management
  StreamSubscription<QueryResult>? _messageSubscription;
  bool _isSubscriptionActive = false;
  bool _shouldMaintainConnection = false;

  // Current room tracking
  String? _currentSenderRoomId;
  String? _currentReceiverRoomId;
  String? _currentUserId;

  // Reconnection logic
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  static const Duration reconnectDelay = Duration(seconds: 3);

  SubscribeChatMessageBloc({required this.chatGraphQLHttpService})
    : super(SubscribeChatMessageInitial()) {
    on<StartSubscribeChatMessageEvent>(_onStartSubscription);
    on<StopSubscribeChatMessageEvent>(_onStopSubscription);
    on<EnsureSubscriptionActiveEvent>(_onEnsureSubscriptionActive);
    on<ReconnectSubscriptionEvent>(_onReconnectSubscription);
  }

  Future<void> _onStartSubscription(
    StartSubscribeChatMessageEvent event,
    Emitter<SubscribeChatMessageState> emit,
  ) async {
    AppLoggerHelper.logInfo(
      '🚀 Starting subscription for sID: ${event.senderRoomId}, rID: ${event.recieverRoomId}, userID: ${event.userId}',
    );

    // If already subscribed to the same room with active connection, don't recreate
    if (_isSubscriptionActive &&
        _currentSenderRoomId == event.senderRoomId &&
        _currentReceiverRoomId == event.recieverRoomId &&
        _currentUserId == event.userId &&
        _messageSubscription != null) {
      AppLoggerHelper.logInfo('✅ Subscription already active for this room');
      return;
    }

    // Validate room IDs
    if (event.senderRoomId.isEmpty ||
        event.recieverRoomId.isEmpty ||
        event.userId.isEmpty ||
        event.senderRoomId == 'undefined' ||
        event.recieverRoomId == 'undefined' ||
        event.userId == 'undefined') {
      AppLoggerHelper.logError('❌ Invalid room IDs or user ID');
      emit(GetSubscribeChatMessageError(message: 'Invalid room IDs provided'));
      return;
    }

    // Set tracking variables before starting subscription
    _currentSenderRoomId = event.senderRoomId;
    _currentReceiverRoomId = event.recieverRoomId;
    _currentUserId = event.userId;
    _shouldMaintainConnection = true;

    // Close existing subscription if different room or inactive
    if (_messageSubscription != null) {
      AppLoggerHelper.logInfo('🔄 Closing existing subscription...');
      await _closeSubscription();
    }

    emit(GetSubscribeChatMessageLoading());
    AppLoggerHelper.logInfo('⏳ Emitted loading state');

    try {
      final subscriptionQuery =
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
  }
}
''';

      AppLoggerHelper.logInfo('📝 Subscription query prepared');
      AppLoggerHelper.logInfo('🔌 Calling performSubscribe...');

      final stream = chatGraphQLHttpService.performSubscribe(subscriptionQuery);
      AppLoggerHelper.logInfo('📡 Stream created, setting up listener...');

      _messageSubscription = stream.listen(
        (result) {
          AppLoggerHelper.logInfo("🔥 SUBSCRIPTION DATA RECEIVED!");
          AppLoggerHelper.logInfo("📦 Full result: $result");
          AppLoggerHelper.logInfo("📦 Has exception: ${result.hasException}");
          AppLoggerHelper.logInfo("📦 Exception: ${result.exception}");
          AppLoggerHelper.logInfo("📦 Data: ${result.data}");
          AppLoggerHelper.logInfo("📦 Data type: ${result.data.runtimeType}");
          AppLoggerHelper.logInfo("📦 Source: ${result.source}");

          // Reset reconnect attempts on successful data
          _reconnectAttempts = 0;

          if (result.hasException) {
            AppLoggerHelper.logError(
              '❌ Subscription exception: ${result.exception.toString()}',
            );
            if (!emit.isDone) {
              emit(
                GetSubscribeChatMessageError(
                  message: result.exception.toString(),
                ),
              );
            }
            return;
          }

          if (result.data == null) {
            AppLoggerHelper.logWarning('⚠️ Result data is null');
            return;
          }

          // Print the entire data structure to understand the format
          AppLoggerHelper.logInfo('📊 Complete data structure:');
          result.data?.forEach((key, value) {
            AppLoggerHelper.logInfo(
              '   Key: $key, Value: $value, Type: ${value.runtimeType}',
            );
          });

          final data = result.data?['View_User_Chat_Message_'];
          AppLoggerHelper.logInfo('🔍 View_User_Chat_Message_ data: $data');
          AppLoggerHelper.logInfo(
            '🔍 View_User_Chat_Message_ type: ${data.runtimeType}',
          );

          if (data == null) {
            AppLoggerHelper.logWarning(
              '⚠️ View_User_Chat_Message_ is null in result',
            );
            return;
          }

          try {
            AppLoggerHelper.logInfo('🔄 Attempting to parse chat data...');
            AppLoggerHelper.logInfo('📋 Data to parse: $data');

            final chatData = ChatData.fromJson(data);
            AppLoggerHelper.logInfo('✅ Chat data parsed successfully');
            AppLoggerHelper.logInfo(
              '💬 Messages count: ${chatData.messages.length}',
            );
            AppLoggerHelper.logInfo('💬 Messages: ${chatData.messages}');
            AppLoggerHelper.logInfo(
              '📱 Is receiver online: ${chatData.isReceiverOnline}',
            );

            if (!emit.isDone) {
              emit(GetSubscribeChatMessageSuccess(chatMessage: chatData));
            }
          } catch (parseError, stackTrace) {
            AppLoggerHelper.logError('❌ Error parsing chat data: $parseError');
            AppLoggerHelper.logError('📋 Data that failed to parse: $data');
            AppLoggerHelper.logError('🔍 Stack trace: $stackTrace');

            if (!emit.isDone) {
              emit(
                GetSubscribeChatMessageError(
                  message: 'Failed to parse chat data: $parseError',
                ),
              );
            }
          }
        },
        onError: (error, stackTrace) {
          AppLoggerHelper.logError("❌ SUBSCRIPTION STREAM ERROR: $error");
          AppLoggerHelper.logError("📋 Error type: ${error.runtimeType}");
          AppLoggerHelper.logError("🔍 Stack trace: $stackTrace");
          _isSubscriptionActive = false;

          if (!emit.isDone) {
            emit(GetSubscribeChatMessageError(message: error.toString()));
          }

          // Only attempt reconnection if we should maintain connection
          if (_shouldMaintainConnection) {
            _scheduleReconnection();
          }
        },
        onDone: () {
          AppLoggerHelper.logInfo("🔚 SUBSCRIPTION STREAM COMPLETED");
          _isSubscriptionActive = false;

          // Only attempt reconnection if we should maintain connection
          if (_shouldMaintainConnection) {
            AppLoggerHelper.logInfo("🔄 Scheduling reconnection...");
            _scheduleReconnection();
          }
        },
        cancelOnError: false,
      );

      _isSubscriptionActive = true;
      AppLoggerHelper.logInfo(
        "✅ Subscription listener established successfully",
      );
    } catch (e, stackTrace) {
      AppLoggerHelper.logError('💥 FAILED TO ESTABLISH SUBSCRIPTION: $e');
      AppLoggerHelper.logError('📋 Error type: ${e.runtimeType}');
      AppLoggerHelper.logError('🔍 Stack trace: $stackTrace');
      _isSubscriptionActive = false;

      if (!emit.isDone) {
        emit(GetSubscribeChatMessageError(message: e.toString()));
      }

      if (_shouldMaintainConnection) {
        _scheduleReconnection();
      }
    }
  }

  Future<void> _onStopSubscription(
    StopSubscribeChatMessageEvent event,
    Emitter<SubscribeChatMessageState> emit,
  ) async {
    AppLoggerHelper.logInfo('🛑 Stopping chat subscription...');
    _shouldMaintainConnection = false;
    await _closeSubscription();
  }

  Future<void> _onEnsureSubscriptionActive(
    EnsureSubscriptionActiveEvent event,
    Emitter<SubscribeChatMessageState> emit,
  ) async {
    AppLoggerHelper.logInfo('🔍 Ensuring subscription is active...');
    _shouldMaintainConnection = true;
    if (!_isSubscriptionActiveForRoom(
      event.senderRoomId,
      event.recieverRoomId,
      event.userId,
    )) {
      AppLoggerHelper.logInfo(
        '🔄 Subscription not active, starting new one...',
      );
      add(
        StartSubscribeChatMessageEvent(
          senderRoomId: event.senderRoomId,
          recieverRoomId: event.recieverRoomId,
          userId: event.userId,
        ),
      );
    } else {
      AppLoggerHelper.logInfo('✅ Subscription already active');
    }
  }

  Future<void> _onReconnectSubscription(
    ReconnectSubscriptionEvent event,
    Emitter<SubscribeChatMessageState> emit,
  ) async {
    AppLoggerHelper.logInfo('🔄 Reconnection event triggered');
    if (_currentSenderRoomId != null &&
        _currentReceiverRoomId != null &&
        _currentUserId != null) {
      add(
        StartSubscribeChatMessageEvent(
          senderRoomId: _currentSenderRoomId!,
          recieverRoomId: _currentReceiverRoomId!,
          userId: _currentUserId!,
        ),
      );
    }
  }

  // Enhanced reconnection logic
  void _scheduleReconnection() {
    if (_reconnectAttempts >= maxReconnectAttempts) {
      AppLoggerHelper.logError(
        "🚫 Max reconnection attempts ($maxReconnectAttempts) reached. Stopping reconnection.",
      );
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectAttempts++;

    final delay = Duration(
      seconds: reconnectDelay.inSeconds * _reconnectAttempts,
    );
    AppLoggerHelper.logInfo(
      "⏰ Scheduling reconnection attempt $_reconnectAttempts/$maxReconnectAttempts in ${delay.inSeconds} seconds",
    );

    _reconnectTimer = Timer(delay, () {
      if (_shouldMaintainConnection &&
          _currentSenderRoomId != null &&
          _currentReceiverRoomId != null &&
          _currentUserId != null) {
        AppLoggerHelper.logInfo(
          "🔄 Attempting reconnection $_reconnectAttempts...",
        );
        add(const ReconnectSubscriptionEvent());
      }
    });
  }

  // Enhanced subscription cleanup
  Future<void> _closeSubscription() async {
    _reconnectTimer?.cancel();
    if (_messageSubscription != null) {
      try {
        await _messageSubscription!.cancel();
        AppLoggerHelper.logInfo("✅ Subscription closed successfully");
      } catch (e) {
        AppLoggerHelper.logError("❌ Error canceling subscription: $e");
      }
      _messageSubscription = null;
      _isSubscriptionActive = false;
    }
  }

  // Check if subscription is active for current room
  bool _isSubscriptionActiveForRoom(String sID, String rID, String userId) {
    return _isSubscriptionActive &&
        _currentSenderRoomId == sID &&
        _currentReceiverRoomId == rID &&
        _currentUserId == userId &&
        _messageSubscription != null;
  }

  @override
  Future<void> close() async {
    AppLoggerHelper.logInfo('🔒 Closing SubscribeChatMessageBloc');
    _shouldMaintainConnection = false;
    await _closeSubscription();
    return super.close();
  }
}
