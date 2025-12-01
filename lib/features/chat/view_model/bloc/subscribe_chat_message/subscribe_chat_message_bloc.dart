import 'dart:async';
import 'dart:math';
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
  Timer? _healthCheckTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

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

    on<StopSubscribeChatMessageEvent>(_onStopSubscription);
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

      // Use a Completer to handle the first data without blocking
      final completer = Completer<void>();

      _messageSubscription = stream.listen(
        (result) {
          AppLoggerHelper.logInfo("🔥 SUBSCRIPTION DATA RECEIVED!");

          // Complete the completer on first successful data
          if (!completer.isCompleted) {
            completer.complete();
            AppLoggerHelper.logInfo(
              '✅ First data received, subscription active',
            );
          }

          // Reset reconnect attempts on successful data
          _reconnectAttempts = 0;

          if (result.hasException) {
            AppLoggerHelper.logError(
              '❌ Subscription exception: ${result.exception}',
            );
            if (!emit.isDone) {
              emit(
                GetSubscribeChatMessageError(
                  message: 'Subscription error: ${result.exception}',
                ),
              );
            }
            return;
          }

          if (result.data == null) {
            AppLoggerHelper.logWarning('⚠️ Result data is null');
            return;
          }

          final data = result.data?['View_User_Chat_Message_'];
          AppLoggerHelper.logInfo('🔍 View_User_Chat_Message_ data received');

          if (data == null) {
            AppLoggerHelper.logWarning('⚠️ View_User_Chat_Message_ is null');
            return;
          }

          try {
            AppLoggerHelper.logInfo('🔄 Attempting to parse chat data...');
            final chatData = ChatData.fromJson(data);
            AppLoggerHelper.logInfo('✅ Chat data parsed successfully');
            AppLoggerHelper.logInfo(
              '💬 Messages count: ${chatData.messages.length}',
            );

            if (!emit.isDone) {
              emit(GetSubscribeChatMessageSuccess(chatMessage: chatData));
              AppLoggerHelper.logInfo('🎯 Success state emitted to UI');
            }
          } catch (parseError, stackTrace) {
            AppLoggerHelper.logError('❌ Error parsing chat data: $parseError');
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
          AppLoggerHelper.logError("📋 Stack trace: $stackTrace");
          _isSubscriptionActive = false;

          // Complete the completer on error too
          if (!completer.isCompleted) {
            completer.completeError(error);
          }

          if (!emit.isDone) {
            emit(GetSubscribeChatMessageError(message: 'Stream error: $error'));
          }

          // Always attempt reconnection on stream errors
          if (_shouldMaintainConnection) {
            _scheduleReconnection();
          }
        },
        onDone: () {
          AppLoggerHelper.logInfo("🔚 SUBSCRIPTION STREAM COMPLETED");
          _isSubscriptionActive = false;

          // Complete the completer if stream completes before first data
          if (!completer.isCompleted) {
            completer.complete();
          }

          // Always attempt reconnection when stream completes
          if (_shouldMaintainConnection) {
            AppLoggerHelper.logInfo(
              "🔄 Stream completed, scheduling reconnection...",
            );
            _scheduleReconnection();
          }
        },
        cancelOnError: false,
      );

      // Wait for first data or timeout with proper error handling
      try {
        await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            AppLoggerHelper.logWarning(
              "⏰ Timeout waiting for first subscription data",
            );
            // Return a completed future instead of null
            return Future.value();
          },
        );
      } catch (e) {
        AppLoggerHelper.logError('❌ Error waiting for first data: $e');
        // Don't rethrow, continue with subscription setup
      }

      _isSubscriptionActive = true;
      AppLoggerHelper.logInfo(
        "✅ Subscription listener established successfully",
      );

      // Start health checks
      _startHealthChecks();
    } catch (e, stackTrace) {
      AppLoggerHelper.logError('💥 FAILED TO ESTABLISH SUBSCRIPTION: $e');
      AppLoggerHelper.logError('🔍 Stack trace: $stackTrace');
      _isSubscriptionActive = false;

      if (!emit.isDone) {
        emit(
          GetSubscribeChatMessageError(
            message: 'Failed to establish subscription: $e',
          ),
        );
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

  void _startHealthChecks() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isSubscriptionActive && _shouldMaintainConnection) {
        AppLoggerHelper.logInfo(
          '❤️ Health check: Subscription inactive, reconnecting...',
        );
        _scheduleReconnection();
      } else if (_isSubscriptionActive) {
        AppLoggerHelper.logInfo(
          '❤️ Health check: Subscription active and healthy',
        );
      }
    });
  }

  void _scheduleReconnection() {
    if (!_shouldMaintainConnection) {
      AppLoggerHelper.logInfo(
        '🛑 Reconnection cancelled: should not maintain connection',
      );
      return;
    }

    if (_reconnectAttempts >= _maxReconnectAttempts) {
      AppLoggerHelper.logError(
        "🚫 Max reconnection attempts ($_maxReconnectAttempts) reached",
      );
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectAttempts++;

    // Exponential backoff: 2, 4, 8, 16, 32 seconds
    final delay = Duration(seconds: pow(2, _reconnectAttempts).toInt());

    AppLoggerHelper.logInfo(
      "⏰ Scheduling reconnection attempt $_reconnectAttempts/$_maxReconnectAttempts in ${delay.inSeconds}s",
    );

    _reconnectTimer = Timer(delay, () {
      if (_shouldMaintainConnection &&
          _currentSenderRoomId != null &&
          _currentReceiverRoomId != null &&
          _currentUserId != null) {
        AppLoggerHelper.logInfo(
          "🔄 Executing reconnection attempt $_reconnectAttempts",
        );
        add(
          StartSubscribeChatMessageEvent(
            senderRoomId: _currentSenderRoomId!,
            recieverRoomId: _currentReceiverRoomId!,
            userId: _currentUserId!,
          ),
        );
      } else {
        AppLoggerHelper.logInfo('🛑 Reconnection cancelled: missing room data');
      }
    });
  }

  Future<void> _closeSubscription() async {
    _healthCheckTimer?.cancel();
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

  @override
  Future<void> close() async {
    AppLoggerHelper.logInfo('🔒 Closing SubscribeChatMessageBloc');
    _shouldMaintainConnection = false;
    _healthCheckTimer?.cancel();
    _reconnectTimer?.cancel();
    await _closeSubscription();
    return super.close();
  }
}
