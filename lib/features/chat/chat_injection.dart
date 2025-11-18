import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/chat/view_model/bloc/doctor_list/doctor_list_bloc.dart';

final GetIt getIt = GetIt.instance;

void initChatInjection() {
  // Doctor list Bloc
  getIt.registerFactory(
    () => DoctorListBloc(graphQLService: getIt<GraphQLService>()),
  );
}
