import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/chat_graphql_service.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/doctor_list/doctor_list_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/send_chat_message/send_chat_message_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/subscribe_chat_message/subscribe_chat_message_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/view_user_chat_home/view_user_chat_home_bloc.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/view_user_chat_room_message/view_user_chat_room_message_bloc.dart';

final GetIt getIt = GetIt.instance;

void initChatInjection() {
  // Doctor list Bloc
  getIt.registerFactory(
    () => DoctorListBloc(graphQLService: getIt<GraphQLService>()),
  );

  // View User Chat Room Message Bloc
  getIt.registerFactory(
    () => ViewUserChatRoomMessageBloc(
      chatGraphQLHttpService: getIt<ChatGraphQLHttpService>(),
    ),
  );

  // Subscribe Chat Message Bloc
  getIt.registerLazySingleton(
    () => SubscribeChatMessageBloc(
      chatGraphQLHttpService: getIt<ChatGraphQLHttpService>(),
    ),
  );

  // Send Chat Message Bloc
  getIt.registerFactory(
    () => SendChatMessageBloc(
      chatGraphQLHttpService: getIt<ChatGraphQLHttpService>(),
    ),
  );

  // View User Chat Home Bloc
  getIt.registerFactory(
    () => ViewUserChatHomeBloc(
      chatGraphQLHttpService: getIt<ChatGraphQLHttpService>(),
    ),
  );
}
