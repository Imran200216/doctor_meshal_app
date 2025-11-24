import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'view_user_chat_room_event.dart';

part 'view_user_chat_room_state.dart';

class ViewUserChatRoomBloc
    extends Bloc<ViewUserChatRoomEvent, ViewUserChatRoomState> {
  final ChatGraphQLHttpService chatGraphQLHttpService;

  ViewUserChatRoomBloc({required this.chatGraphQLHttpService})
    : super(ViewUserChatRoomInitial()) {
    on<GetViewChatRoomEvent>((event, emit) async {
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
          emit(GetViewUserChatRoomFailure(message: "No data found"));
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
}
