import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_home_model.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'view_user_chat_home_event.dart';

part 'view_user_chat_home_state.dart';

class ViewUserChatHomeBloc
    extends Bloc<ViewUserChatHomeEvent, ViewUserChatHomeState> {
  final ChatGraphQLHttpService chatGraphQLHttpService;

  // Subscription management
  StreamSubscription<QueryResult>? _homeSubscription;
  bool _isSubscriptionActive = false;
  bool _shouldMaintainConnection = false;

  // Current user tracking
  String? _currentUserId;

  // Reconnection logic
  Timer? _reconnectTimer;
  Timer? _healthCheckTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  ViewUserChatHomeBloc({required this.chatGraphQLHttpService})
    : super(ViewUserChatHomeInitial()) {
    on<GetViewUserChatHomeEvent>(_onGetViewUserChatHome);
    on<StopViewUserChatHomeSubscriptionEvent>(_onStopSubscription);
    on<ReconnectHomeSubscriptionEvent>(_onReconnectSubscription);
  }

  Future<void> _onGetViewUserChatHome(
    GetViewUserChatHomeEvent event,
    Emitter<ViewUserChatHomeState> emit,
  ) async {
    AppLoggerHelper.logInfo(
      '🚀 Starting home subscription for user: ${event.userId}',
    );

    // Validate user ID
    if (event.userId.isEmpty || event.userId == 'undefined') {
      AppLoggerHelper.logError('❌ Invalid user ID');
      emit(GetViewUserChatHomeFailure(message: 'Invalid user ID provided'));
      return;
    }

    // Close existing subscription first
    await _closeSubscription();

    _currentUserId = event.userId;
    _shouldMaintainConnection = true;

    emit(GetViewUserChatHomeLoading());
    AppLoggerHelper.logInfo('⏳ Emitted home loading state');

    try {
      final subscriptionQuery =
          '''   
      subscription Subscription {
        View_User_Chat_Home_(user_id: "${event.userId}") {
          data {
            id
            last_message
            last_message_time
            un_read_count
            reciever_id {
              id
              first_name
              last_name
              profile_image
            }
            chat_room_id {
              id
            }
          }
        }
      }
    ''';

      AppLoggerHelper.logInfo('📝 Home subscription query prepared');

      final stream = chatGraphQLHttpService.performSubscribe(subscriptionQuery);
      AppLoggerHelper.logInfo('📡 Home stream created');

      bool hasReceivedData = false;

      _homeSubscription = stream.listen(
        (result) {
          AppLoggerHelper.logInfo("🔥 HOME SUBSCRIPTION DATA RECEIVED!");
          hasReceivedData = true;
          _reconnectAttempts = 0; // Reset on successful data

          if (result.hasException) {
            AppLoggerHelper.logError(
              '❌ Home subscription exception: ${result.exception}',
            );
            if (!emit.isDone) {
              emit(
                GetViewUserChatHomeFailure(
                  message: 'Home subscription error: ${result.exception}',
                ),
              );
            }
            return;
          }

          if (result.data == null) {
            AppLoggerHelper.logWarning('⚠️ Home result data is null');
            return;
          }

          // 🎯 ENHANCED LOGGING - Log the complete raw data
          AppLoggerHelper.logInfo('📊 COMPLETE RAW RESULT DATA:');
          AppLoggerHelper.logInfo('${result.data}');

          AppLoggerHelper.logInfo(
            '🔍 Checking View_User_Chat_Home_ structure...',
          );

          final viewUserChatHomeData = result.data?['View_User_Chat_Home_'];
          AppLoggerHelper.logInfo(
            '📋 View_User_Chat_Home_ object: $viewUserChatHomeData',
          );

          if (viewUserChatHomeData == null) {
            AppLoggerHelper.logWarning('⚠️ View_User_Chat_Home_ is null');
            return;
          }

          // 🎯 SPECIFIC LOGGING FOR THE DATA ARRAY
          final dataArray = viewUserChatHomeData['data'];
          AppLoggerHelper.logInfo(
            '🎯 View_User_Chat_Home_.data array: $dataArray',
          );

          if (dataArray == null) {
            AppLoggerHelper.logWarning('⚠️ View_User_Chat_Home_.data is null');
            return;
          }

          if (dataArray is List) {
            AppLoggerHelper.logInfo(
              '📈 Number of chat rooms: ${dataArray.length}',
            );

            // Log each chat room item
            for (int i = 0; i < dataArray.length; i++) {
              final chatRoom = dataArray[i];
              AppLoggerHelper.logInfo('💬 Chat Room $i:');
              AppLoggerHelper.logInfo('   - ID: ${chatRoom['id']}');
              AppLoggerHelper.logInfo(
                '   - Last Message: ${chatRoom['last_message']}',
              );
              AppLoggerHelper.logInfo(
                '   - Last Message Time: ${chatRoom['last_message_time']}',
              );
              AppLoggerHelper.logInfo(
                '   - Unread Count: ${chatRoom['un_read_count']}',
              );

              final receiver = chatRoom['reciever_id'];
              if (receiver != null) {
                AppLoggerHelper.logInfo(
                  '   - Receiver: ${receiver['first_name']} ${receiver['last_name']}',
                );
              }

              final chatRoomId = chatRoom['chat_room_id'];
              if (chatRoomId != null) {
                AppLoggerHelper.logInfo(
                  '   - Chat Room ID: ${chatRoomId['id']}',
                );
              }
            }
          } else {
            AppLoggerHelper.logError(
              '❌ Expected List but got: ${dataArray.runtimeType}',
            );
          }

          try {
            AppLoggerHelper.logInfo(
              '🔄 Attempting to parse with ViewUserChatHomeModel...',
            );
            final chatHomeData = ViewUserChatHomeModel.fromJson(
              viewUserChatHomeData,
            );
            AppLoggerHelper.logInfo('✅ Home chat data parsed successfully');
            AppLoggerHelper.logInfo(
              '💬 Final parsed chat rooms count: ${chatHomeData.data.length}',
            );

            if (!emit.isDone) {
              emit(
                GetViewUserChatHomeSuccess(viewUserChatHomeModel: chatHomeData),
              );
              AppLoggerHelper.logInfo(
                '🎉 Success state emitted with chat data',
              );
            }
          } catch (parseError, stackTrace) {
            AppLoggerHelper.logError(
              '❌ Error parsing home chat data: $parseError',
            );
            AppLoggerHelper.logError('📝 Stack trace: $stackTrace');

            // 🎯 ADDITIONAL DEBUGGING - Check what fields are available
            AppLoggerHelper.logInfo(
              '🔍 Available keys in viewUserChatHomeData:',
            );
            if (viewUserChatHomeData is Map) {
              viewUserChatHomeData.keys.forEach((key) {
                AppLoggerHelper.logInfo(
                  '   - $key: ${viewUserChatHomeData[key]}',
                );
              });
            }

            if (!emit.isDone) {
              emit(
                GetViewUserChatHomeFailure(
                  message: 'Failed to parse home chat data: $parseError',
                ),
              );
            }
          }
        },
        onError: (error, stackTrace) {
          AppLoggerHelper.logError("❌ HOME SUBSCRIPTION STREAM ERROR: $error");
          _isSubscriptionActive = false;

          if (!emit.isDone) {
            emit(
              GetViewUserChatHomeFailure(message: 'Home stream error: $error'),
            );
          }

          if (_shouldMaintainConnection) {
            _scheduleReconnection();
          }
        },
        onDone: () {
          AppLoggerHelper.logInfo("🔚 HOME SUBSCRIPTION STREAM COMPLETED");
          _isSubscriptionActive = false;

          if (_shouldMaintainConnection) {
            AppLoggerHelper.logInfo("🔄 Stream completed, reconnecting...");
            _scheduleReconnection();
          }
        },
        cancelOnError: true,
      );

      // Set a timer to check if we receive data within a reasonable time
      Timer(const Duration(seconds: 15), () {
        if (!hasReceivedData && _isSubscriptionActive) {
          AppLoggerHelper.logWarning(
            "⏰ No data received after 15 seconds, triggering reconnection",
          );
          if (_shouldMaintainConnection) {
            _scheduleReconnection();
          }
        }
      });

      _isSubscriptionActive = true;
      AppLoggerHelper.logInfo("✅ Home subscription setup completed");

      _startHealthChecks();
    } catch (e, stackTrace) {
      AppLoggerHelper.logError('💥 FAILED TO ESTABLISH HOME SUBSCRIPTION: $e');
      _isSubscriptionActive = false;

      if (!emit.isDone) {
        emit(
          GetViewUserChatHomeFailure(
            message: 'Failed to establish home subscription: $e',
          ),
        );
      }

      if (_shouldMaintainConnection) {
        _scheduleReconnection();
      }
    }
  }

  Future<void> _onStopSubscription(
    StopViewUserChatHomeSubscriptionEvent event,
    Emitter<ViewUserChatHomeState> emit,
  ) async {
    AppLoggerHelper.logInfo('🛑 Stopping home chat subscription...');
    _shouldMaintainConnection = false;
    await _closeSubscription();
  }

  Future<void> _onReconnectSubscription(
    ReconnectHomeSubscriptionEvent event,
    Emitter<ViewUserChatHomeState> emit,
  ) async {
    AppLoggerHelper.logInfo('🔄 Home reconnection event triggered');
    if (_currentUserId != null) {
      add(GetViewUserChatHomeEvent(userId: _currentUserId!));
    }
  }

  void _startHealthChecks() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isSubscriptionActive && _shouldMaintainConnection) {
        AppLoggerHelper.logInfo(
          '❤️ Home health check: Subscription inactive, reconnecting...',
        );
        _scheduleReconnection();
      } else if (_isSubscriptionActive) {
        AppLoggerHelper.logInfo(
          '❤️ Home health check: Subscription active and healthy',
        );
      }
    });
  }

  void _scheduleReconnection() {
    if (!_shouldMaintainConnection) {
      AppLoggerHelper.logInfo(
        '🛑 Home reconnection cancelled: should not maintain connection',
      );
      return;
    }

    if (_reconnectAttempts >= _maxReconnectAttempts) {
      AppLoggerHelper.logError(
        "🚫 Max home reconnection attempts ($_maxReconnectAttempts) reached",
      );
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectAttempts++;

    // Exponential backoff: 2, 4, 8, 16, 32 seconds
    final delay = Duration(seconds: pow(2, _reconnectAttempts).toInt());

    AppLoggerHelper.logInfo(
      "⏰ Scheduling home reconnection attempt $_reconnectAttempts/$_maxReconnectAttempts in ${delay.inSeconds}s",
    );

    _reconnectTimer = Timer(delay, () {
      if (_shouldMaintainConnection && _currentUserId != null) {
        AppLoggerHelper.logInfo(
          "🔄 Executing home reconnection attempt $_reconnectAttempts",
        );
        add(GetViewUserChatHomeEvent(userId: _currentUserId!));
      } else {
        AppLoggerHelper.logInfo(
          '🛑 Home reconnection cancelled: missing user data',
        );
      }
    });
  }

  Future<void> _closeSubscription() async {
    _healthCheckTimer?.cancel();
    _reconnectTimer?.cancel();

    if (_homeSubscription != null) {
      try {
        await _homeSubscription!.cancel();
        AppLoggerHelper.logInfo("✅ Home subscription closed successfully");
      } catch (e) {
        AppLoggerHelper.logError("❌ Error canceling home subscription: $e");
      }
      _homeSubscription = null;
      _isSubscriptionActive = false;
    }
  }

  @override
  Future<void> close() async {
    AppLoggerHelper.logInfo('🔒 Closing ViewUserChatHomeBloc');
    _shouldMaintainConnection = false;
    _healthCheckTimer?.cancel();
    _reconnectTimer?.cancel();
    await _closeSubscription();
    return super.close();
  }
}
