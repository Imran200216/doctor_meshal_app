import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';

part 'view_notification_un_read_count_event.dart';

part 'view_notification_un_read_count_state.dart';

class ViewNotificationUnReadCountBloc
    extends
        Bloc<
          ViewNotificationUnReadCountEvent,
          ViewNotificationUnReadCountState
        > {
  final GraphQLService graphQLService;

  ViewNotificationUnReadCountBloc({required this.graphQLService})
    : super(ViewNotificationUnReadCountInitial()) {
    on<GetViewNotificationUnReadCountEvent>((event, emit) async {
      emit(ViewNotificationUnReadCountLoading());

      try {
        String query =
            '''
          query Query {
            get_app_notification_unread_count_(user_id: "${event.userId}")
          }
        ''';

        final result = await graphQLService.performQuery(query);

        if (result.data == null) {
          throw Exception("GraphQL returned null data");
        }

        final unreadCount =
            result.data?['get_app_notification_unread_count_'] ?? 0;

        emit(
          ViewNotificationUnReadCountLoaded(
            unreadNotificationCount: unreadCount,
          ),
        );
      } catch (e) {
        emit(ViewNotificationUnReadCountFailure(message: e.toString()));
      }
    });
  }
}
