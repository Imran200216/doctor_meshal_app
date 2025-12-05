import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/features/chat/chat.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';

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

  // Subscribe Chat Message Bloc (Register Factory)
  getIt.registerFactory(
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

  // Query View User Chat Home Bloc
  getIt.registerFactory(
    () => QueryViewUserChatHomeBloc(
      chatGraphQLHttpService: getIt<ChatGraphQLHttpService>(),
    ),
  );

  // Stop Chat Message Subscription Bloc
  getIt.registerFactory(
    () => StopChatMessageSubscriptionsBloc(
      chatGraphQLHttpService: getIt<ChatGraphQLHttpService>(),
    ),
  );
}
