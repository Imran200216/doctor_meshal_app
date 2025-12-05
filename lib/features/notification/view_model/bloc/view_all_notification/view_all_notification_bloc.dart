import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/notification/model/notification_model.dart';

part 'view_all_notification_event.dart';

part 'view_all_notification_state.dart';

class ViewAllNotificationBloc
    extends Bloc<ViewAllNotificationEvent, ViewAllNotificationState> {
  final GraphQLService graphQLService;

  ViewAllNotificationBloc({required this.graphQLService})
    : super(ViewAllNotificationInitial()) {
    on<GetViewAllNotificationEvent>((event, emit) async {
      emit(ViewAllNotificationLoading());

      try {
        AppLoggerHelper.logInfo(
          "Fetching notifications for userId: ${event.userId}",
        );

        String query =
            '''
        query View_all_app_notification_ {
          view_all_app_notification_(user_id: "${event.userId}") {
            createdAt
            description
            id
            title
          }
        }
        ''';

        final result = await graphQLService.performQuery(query);

        AppLoggerHelper.logInfo("Raw GraphQL Response: ${result.data}");

        if (result.data == null) {
          throw Exception("GraphQL returned null data");
        }

        // SAFE PARSE
        final response = NotificationResponse.fromJson(result.data!);

        AppLoggerHelper.logInfo(
          "Parsed NotificationResponse: ${response.toJson()}",
        );

        emit(ViewAllNotificationLoaded(notificationResponse: response));

        AppLoggerHelper.logInfo("ViewAllNotificationLoaded emitted");
      } catch (e, stack) {
        AppLoggerHelper.logError("Error fetching notifications: $e");
        AppLoggerHelper.logError("STACK TRACE: $stack");

        emit(ViewAllNotificationFailure(message: e.toString()));
      }
    });
  }
}
