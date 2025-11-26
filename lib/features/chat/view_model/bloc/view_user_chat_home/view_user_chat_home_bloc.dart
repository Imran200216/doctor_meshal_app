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

  // Data storage
  ViewUserChatHomeModel? _lastSuccessfulData;
  String? _currentNotificationCount;

  // Current user tracking
  String? _currentUserId;

  // Reconnection & query timers
  Timer? _reconnectTimer;
  Timer? _healthCheckTimer;
  Timer? _queryTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  ViewUserChatHomeBloc({required this.chatGraphQLHttpService})
    : super(ViewUserChatHomeInitial()) {
    // ------------------------ Get View User Chat Home Event -----------------------
    on<GetViewUserChatHomeEvent>((event, emit) async {
      try {
        AppLoggerHelper.logInfo(
          "🎯 Starting GetViewUserChatHomeEvent for user: ${event.userId}",
        );

        String subscription =
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

        AppLoggerHelper.logInfo("📡 GraphQL Subscription Query: $subscription");

        final stream = chatGraphQLHttpService.performSubscribe(subscription);

        await emit.forEach(
          stream,
          onData: (result) {
            AppLoggerHelper.logInfo(
              "📨 Received data from subscription stream",
            );
            AppLoggerHelper.logInfo("📊 Raw result data: ${result.data}");
            AppLoggerHelper.logInfo(
              "🔧 Result hasException: ${result.hasException}",
            );

            // ❌ Exception check
            if (result.hasException) {
              AppLoggerHelper.logError(
                "❌ Subscription GraphQL Exception: ${result.exception}",
              );
              AppLoggerHelper.logError(
                "❌ GraphQL Errors: ${result.exception?.graphqlErrors}",
              );
              return GetViewUserChatHomeFailure(
                message: "Subscription error: ${result.exception}",
              );
            }

            // Check data structure step by step
            AppLoggerHelper.logInfo("🔍 Checking data structure...");

            final homeData = result.data?['View_User_Chat_Home_'];
            AppLoggerHelper.logInfo(
              "🏠 Home data (View_User_Chat_Home_): $homeData",
            );

            if (homeData == null) {
              AppLoggerHelper.logError(
                "⚠️ homeData is null - Check GraphQL response structure",
              );
              AppLoggerHelper.logInfo(
                "🔍 Available keys in result.data: ${result.data?.keys.toList()}",
              );
              return GetViewUserChatHomeLoading();
            }

            final dataArray = homeData['data'];
            AppLoggerHelper.logInfo("📋 Data array from homeData: $dataArray");
            AppLoggerHelper.logInfo(
              "📊 Data array type: ${dataArray.runtimeType}",
            );
            AppLoggerHelper.logInfo(
              "🔢 Data array length: ${dataArray is List ? dataArray.length : 'N/A'}",
            );

            if (dataArray == null) {
              AppLoggerHelper.logError(
                "⚠️ dataArray is null - No chat data found",
              );
              return GetViewUserChatHomeLoading();
            }

            try {
              final chatData = <ChatHomeData>[];

              if (dataArray is List) {
                AppLoggerHelper.logInfo(
                  "✅ Data array is a List, processing ${dataArray.length} items",
                );

                for (var i = 0; i < dataArray.length; i++) {
                  var item = dataArray[i];
                  AppLoggerHelper.logInfo("🔍 Processing item $i: $item");
                  AppLoggerHelper.logInfo(
                    "📝 Item $i type: ${item.runtimeType}",
                  );

                  if (item is Map<String, dynamic>) {
                    AppLoggerHelper.logInfo(
                      "✅ Item $i is Map, attempting to parse...",
                    );
                    try {
                      var parsedItem = ChatHomeData.fromJson(item);
                      chatData.add(parsedItem);
                      AppLoggerHelper.logInfo(
                        "✅ Successfully parsed item $i: ${parsedItem.reciever.firstName}",
                      );
                    } catch (parseError) {
                      AppLoggerHelper.logError(
                        "❌ Failed to parse item $i: $parseError",
                      );
                    }
                  } else {
                    AppLoggerHelper.logError(
                      "❌ Item $i is not a Map<String, dynamic>, it's: ${item.runtimeType}",
                    );
                  }
                }
              } else {
                AppLoggerHelper.logError(
                  "❌ dataArray is not a List, it's: ${dataArray.runtimeType}",
                );
              }

              AppLoggerHelper.logInfo(
                "📊 Final chatData list has ${chatData.length} items",
              );

              final parsed = ViewUserChatHomeModel(data: chatData);

              AppLoggerHelper.logInfo(
                "✅ Subscription data successfully parsed with ${chatData.length} chat items",
              );

              if (chatData.isEmpty) {
                AppLoggerHelper.logInfo(
                  "ℹ️ No chat items found for user ${event.userId}",
                );
              } else {
                AppLoggerHelper.logInfo(
                  "🎉 Success! Ready to display ${chatData.length} chat items",
                );
              }

              return GetViewUserChatHomeSuccess(viewUserChatHomeModel: parsed);
            } catch (e) {
              AppLoggerHelper.logError("❌ Critical parsing error: $e");
              return GetViewUserChatHomeFailure(message: "Parse error: $e");
            }
          },

          // ❌ Stream error handling
          onError: (e, stackTrace) {
            AppLoggerHelper.logError("❌ Stream subscription error: $e");
            return GetViewUserChatHomeFailure(message: "Stream error: $e");
          },
        );
      } catch (e) {
        AppLoggerHelper.logError("💥 Top-level bloc error: $e");
        emit(GetViewUserChatHomeFailure(message: e.toString()));
      }
    });

    // Stop View User Chat Home Subsctiption Event
    on<StopViewUserChatHomeSubscriptionEvent>(_onStopSubscription);
    on<ReconnectHomeSubscriptionEvent>(_onReconnectSubscription);

    // Get View User Chat Room Event Query
    on<GetViewUserChatRoomEvent>((event, emit) async {
      emit(GetViewUserChatRoomLoading());

      try {
        final query =
            '''
        query View_User_Chatroom_ {
          View_User_Chatroom_(user_id: "${event.userId}") {
            id
            notification_count
          }
        }
        ''';

        AppLoggerHelper.logInfo("GraphQL Query: $query");

        final result = await chatGraphQLHttpService.performQuery(query);

        final raw = result.data?["View_User_Chatroom_"];
        AppLoggerHelper.logInfo("GraphQL RAW Response: $raw");

        // Convert raw into a usable Map
        Map<String, dynamic>? viewUserChatRoom;

        if (raw is List && raw.isNotEmpty) {
          viewUserChatRoom = Map<String, dynamic>.from(raw.first);
        } else if (raw is Map<String, dynamic>) {
          viewUserChatRoom = Map<String, dynamic>.from(raw);
        }

        if (viewUserChatRoom == null) {
          emit(GetViewUserChatHomeFailure(message: "No data found"));
          return;
        }

        final id = viewUserChatRoom['id']?.toString() ?? "";
        final notification =
            viewUserChatRoom['notification_count']?.toString() ?? "0";

        AppLoggerHelper.logInfo("Parsed Notification Count: $notification");

        emit(
          GetViewUserChatRoomSuccess(id: id, notificationCount: notification),
        );
      } catch (e) {
        emit(GetViewUserChatRoomFailure(message: e.toString()));
      }
    });
  }

  // Future<void> _onGetViewUserChatRoom(
  //   GetViewUserChatRoomEvent event,
  //   Emitter<ViewUserChatHomeState> emit,
  // ) async {
  //   AppLoggerHelper.logInfo('📊 Starting ViewUserChatRoom query...');
  //
  //   // If we have subscription data, emit loading with current data
  //   if (_lastSuccessfulData != null) {
  //     emit(
  //       GetViewUserChatHomeSuccess(
  //         viewUserChatHomeModel: _lastSuccessfulData!,
  //         notificationCount: _currentNotificationCount,
  //       ),
  //     );
  //   }
  //
  //   try {
  //     final query =
  //         '''
  //       query View_User_Chatroom_ {
  //         View_User_Chatroom_(user_id: "${event.userId}") {
  //           id
  //           notification_count
  //         }
  //       }
  //       ''';
  //
  //     AppLoggerHelper.logInfo("GraphQL Query: $query");
  //
  //     final result = await chatGraphQLHttpService.performQuery(query);
  //
  //     final raw = result.data?["View_User_Chatroom_"];
  //     AppLoggerHelper.logInfo("GraphQL RAW Response: $raw");
  //
  //     // Convert raw into a usable Map
  //     Map<String, dynamic>? viewUserChatRoom;
  //
  //     if (raw is List && raw.isNotEmpty) {
  //       viewUserChatRoom = Map<String, dynamic>.from(raw.first);
  //     } else if (raw is Map<String, dynamic>) {
  //       viewUserChatRoom = Map<String, dynamic>.from(raw);
  //     }
  //
  //     if (viewUserChatRoom == null) {
  //       AppLoggerHelper.logError("❌ No ViewUserChatRoom data found");
  //       return;
  //     }
  //
  //     final id = viewUserChatRoom['id']?.toString() ?? "";
  //     final notification =
  //         viewUserChatRoom['notification_count']?.toString() ?? "0";
  //
  //     AppLoggerHelper.logInfo("✅ Parsed Notification Count: $notification");
  //
  //     // Store the notification count
  //     _currentNotificationCount = notification;
  //
  //     // 🎯 KEY FIX: Emit success with BOTH subscription data and query data
  //     if (_lastSuccessfulData != null) {
  //       emit(
  //         GetViewUserChatHomeSuccess(
  //           viewUserChatHomeModel: _lastSuccessfulData!,
  //           notificationCount: notification,
  //         ),
  //       );
  //     } else {
  //       emit(
  //         GetViewUserChatRoomSuccess(id: id, notificationCount: notification),
  //       );
  //     }
  //   } catch (e) {
  //     AppLoggerHelper.logError('❌ ViewUserChatRoom query failed: $e');
  //
  //     // Even if query fails, keep the subscription data
  //     if (_lastSuccessfulData != null) {
  //       emit(
  //         GetViewUserChatHomeSuccess(
  //           viewUserChatHomeModel: _lastSuccessfulData!,
  //           notificationCount: _currentNotificationCount,
  //         ),
  //       );
  //     } else {
  //       emit(GetViewUserChatRoomFailure(message: e.toString()));
  //     }
  //   }
  // }

  // 🎯 NEW METHOD: Schedule query call after subscription success
  void _scheduleQueryCall(String userId) {
    _queryTimer?.cancel();

    AppLoggerHelper.logInfo('⏰ Scheduling query in 2 seconds...');
    _queryTimer = Timer(const Duration(seconds: 2), () {
      if (_shouldMaintainConnection && userId.isNotEmpty) {
        AppLoggerHelper.logInfo('📡 Executing query now...');
        add(GetViewUserChatRoomEvent(userId: userId));
      }
    });
  }

  Future<void> _onStopSubscription(
    StopViewUserChatHomeSubscriptionEvent event,
    Emitter<ViewUserChatHomeState> emit,
  ) async {
    AppLoggerHelper.logInfo('🛑 Stopping home chat subscription...');
    _shouldMaintainConnection = false;
    _queryTimer?.cancel();
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
    _queryTimer?.cancel();

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
    _queryTimer?.cancel();
    await _closeSubscription();
    return super.close();
  }
}
