import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/home/view_model/bloc/doctor_dashboard_summary_counts/doctor_dashboard_summary_counts_bloc.dart';
import 'package:meshal_doctor_booking_app/features/home/view_model/bloc/operative_summary_counts/operative_summary_counts_bloc.dart';
import 'package:meshal_doctor_booking_app/features/home/view_model/bloc/user_chat_room/view_user_chat_room_bloc.dart';

final GetIt getIt = GetIt.instance;

void initHomeInjection() {
  // Operative Summary Counts Bloc
  getIt.registerFactory(
    () => OperativeSummaryCountsBloc(graphQLService: getIt<GraphQLService>()),
  );

  // View User Chat Room Bloc
  getIt.registerFactory(
    () => ViewUserChatRoomBloc(
      chatGraphQLHttpService: getIt<ChatGraphQLHttpService>(),
    ),
  );

  // Doctor Dashboard Summary Count Bloc
  getIt.registerFactory(
    () => DoctorDashboardSummaryCountsBloc(
      graphQLService: getIt<GraphQLService>(),
    ),
  );
}
