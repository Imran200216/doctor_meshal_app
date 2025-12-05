import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/notification/notification.dart';

final GetIt getIt = GetIt.instance;

void initNotificationInjection() {
  // View All Notification Bloc
  getIt.registerFactory(
    () => ViewAllNotificationBloc(graphQLService: getIt<GraphQLService>()),
  );

  // View Notification UnRead Count Bloc
  getIt.registerFactory(
    () => ViewNotificationUnReadCountBloc(
      graphQLService: getIt<GraphQLService>(),
    ),
  );
}
