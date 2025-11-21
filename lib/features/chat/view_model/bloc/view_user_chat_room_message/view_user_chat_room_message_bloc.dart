import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';
import 'package:meshal_doctor_booking_app/features/chat/model/view_user_chat_message_model.dart';

part 'view_user_chat_room_message_event.dart';

part 'view_user_chat_room_message_state.dart';

class ViewUserChatRoomMessageBloc
    extends Bloc<ViewUserChatRoomMessageEvent, ViewUserChatRoomMessageState> {
  final ChatGraphQLHttpService chatGraphQLHttpService;

  ViewUserChatRoomMessageBloc({required this.chatGraphQLHttpService})
    : super(ViewUserChatRoomMessageInitial()) {
    // Get Chatroom Messages
    on<GetViewUserChatRoomMessageEvent>((event, emit) async {
      emit(GetViewUserChatRoomMessageLoading());

      try {
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

        // Log result
        AppLoggerHelper.logInfo("📥 Chatroom Query Result: ${result.data}");

        if (result.hasException) {
          emit(
            GetViewUserChatRoomMessageFailure(
              message: result.exception.toString(),
            ),
          );
          return;
        }

        final json = result.data?["View_User_Chat_Message_"];

        if (json == null) {
          emit(
            GetViewUserChatRoomMessageFailure(message: "No chat data received"),
          );
          return;
        }

        // Parse Model
        final messageModel = ChatData.fromJson(json);

        emit(GetViewUserChatRoomMessageSuccess(chatMessage: messageModel));
      } catch (e) {
        emit(GetViewUserChatRoomMessageFailure(message: e.toString()));
      }
    });
  }
}
