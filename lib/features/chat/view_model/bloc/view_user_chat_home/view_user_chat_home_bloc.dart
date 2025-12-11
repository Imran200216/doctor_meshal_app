import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_home_model.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';

part 'view_user_chat_home_event.dart';

part 'view_user_chat_home_state.dart';

class ViewUserChatHomeBloc
    extends Bloc<ViewUserChatHomeEvent, ViewUserChatHomeState> {
  final ChatGraphQLHttpService chatGraphQLHttpService;

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

    // ------------------------ Stop View User Chat Home Subscription Event
    on<StopViewUserChatHomeSubscriptionEvent>((event, emit) {
      AppLoggerHelper.logInfo("🛑 Stopping View User Chat Home subscription");
      emit(ViewUserChatHomeInitial());
    });

    // ------------------------ Reset View User Chat Home State
    on<ResetViewUserChatHomeStateEvent>((event, emit) {
      AppLoggerHelper.logInfo("🔄 Resetting ViewUserChatHomeBloc state");
      emit(ViewUserChatHomeInitial());
    });
  }
}
