import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_message_model.dart';

part 'view_user_chat_room_message_event.dart';

part 'view_user_chat_room_message_state.dart';

class ViewUserChatRoomMessageBloc
    extends Bloc<ViewUserChatRoomMessageEvent, ViewUserChatRoomMessageState> {
  final ChatGraphQLHttpService chatGraphQLHttpService;

  ViewUserChatRoomMessageBloc({required this.chatGraphQLHttpService})
    : super(ViewUserChatRoomMessageInitial()) {
    on<GetViewUserChatRoomMessageEvent>((event, emit) async {
      emit(GetViewUserChatRoomMessageLoading());

      try {
        // ✅ FIX: Remove "room" from the query name to match subscription
        final query =
            '''
          query Query {
            View_User_Chatroom_Message_(
              sender_room_id: "${event.senderRoomId}"
              reciever_room_id: "${event.recieverRoomId}"
              user_id: "${event.userId}"
            )
          }
        ''';

        final result = await chatGraphQLHttpService.performQuery(query);

        AppLoggerHelper.logInfo("📥 Chatroom Query Result: ${result.data}");

        if (result.hasException) {
          emit(
            GetViewUserChatRoomMessageFailure(
              message: result.exception.toString(),
            ),
          );
          return;
        }

        // ✅ FIX: Use the same key as subscription (without "room")
        final json = result.data?["View_User_Chatroom_Message_"];

        if (json == null) {
          emit(
            GetViewUserChatRoomMessageFailure(message: "No chat data received"),
          );
          return;
        }

        AppLoggerHelper.logInfo("🔍 Raw JSON Type: ${json.runtimeType}");
        AppLoggerHelper.logInfo("🔍 Raw JSON Value: $json");

        // ✅ It should now be a Map, not a String
        if (json is! Map<String, dynamic>) {
          emit(
            GetViewUserChatRoomMessageFailure(
              message: "Unexpected data type: ${json.runtimeType}",
            ),
          );
          return;
        }

        AppLoggerHelper.logInfo("🎯 Parsed JSON: $json");

        // Parse Model
        final messageModel = ChatData.fromJson(json);

        emit(GetViewUserChatRoomMessageSuccess(chatMessage: messageModel));
      } catch (e, stackTrace) {
        AppLoggerHelper.logError("❌ Error parsing chat data: $e");
        AppLoggerHelper.logError("Stack trace: $stackTrace");
        emit(GetViewUserChatRoomMessageFailure(message: e.toString()));
      }
    });
  }
}
