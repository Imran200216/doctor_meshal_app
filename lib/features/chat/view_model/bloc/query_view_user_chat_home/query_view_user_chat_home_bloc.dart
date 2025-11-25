import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/utils/app_logger_helper.dart';

part 'query_view_user_chat_home_event.dart';

part 'query_view_user_chat_home_state.dart';

class QueryViewUserChatHomeBloc
    extends Bloc<QueryViewUserChatHomeEvent, QueryViewUserChatHomeState> {
  final ChatGraphQLHttpService chatGraphQLHttpService;

  QueryViewUserChatHomeBloc({required this.chatGraphQLHttpService})
    : super(QueryViewUserChatHomeInitial()) {
    // Get Query View User Chat Home Event
    on<GetQueryViewUserChatHomeEvent>((event, emit) async {
      emit(GetQueryViewUserChatHomeLoading());

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
          emit(GetQueryViewUserChatHomeFailure(message: "No data found"));
          return;
        }

        final id = viewUserChatRoom['id']?.toString() ?? "";
        final notification =
            viewUserChatRoom['notification_count']?.toString() ?? "0";

        AppLoggerHelper.logInfo("Parsed Notification Count: $notification");

        emit(
          GetQueryViewUserChatHomeSuccess(
            id: id,
            notificationCount: notification,
          ),
        );
      } catch (e) {
        emit(GetQueryViewUserChatHomeFailure(message: e.toString()));
      }
    });
  }
}
