import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';

part 'send_chat_message_event.dart';

part 'send_chat_message_state.dart';

class SendChatMessageBloc
    extends Bloc<SendChatMessageEvent, SendChatMessageState> {
  final ChatGraphQLHttpService chatGraphQLHttpService;

  SendChatMessageBloc({required this.chatGraphQLHttpService})
    : super(SendChatMessageInitial()) {
    // Send Chat Message Func Event
    on<SendChatMessageFuncEvent>((event, emit) async {
      emit(SendChatMessageFuncLoading());

      try {
        String mutation =
            ''' 
        
        mutation Send_Chat_Message_ {
  Send_Chat_Message_(
    sender_room_id: "${event.senderRoomId}"
    reciever_room_id: "${event.receiverRoomId}"
    message: "${event.message}"
  )
}
  ''';

        final result = await chatGraphQLHttpService.performMutation(mutation);

        final message = result.data?["Send_Chat_Message_"];

        if (message != null) {
          emit(SendChatMessageFuncSuccess(message: message.toString()));
        } else {
          emit(
            const SendChatMessageFuncFailure(
              message: "Something went wrong while sending message",
            ),
          );
        }
      } catch (e) {
        emit(SendChatMessageFuncFailure(message: e.toString()));
      }
    });
  }
}
