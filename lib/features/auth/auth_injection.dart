import 'package:get_it/get_it.dart';
import 'package:meshal_doctor_booking_app/core/constants/app_api_constants.dart';
import 'package:meshal_doctor_booking_app/core/service/graphql_service.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/email_auth/email_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/bloc/user_auth/user_auth_bloc.dart';
import 'package:meshal_doctor_booking_app/features/auth/view_model/cubit/auth_selected_type_cubit.dart';

final GetIt getIt = GetIt.instance;

void initAuthInjection() {
  // Graphql Service
  getIt.registerLazySingleton(() => GraphQLService(AppApiConstants.baseUrl));

  // Auth Selected Type Cubit
  getIt.registerLazySingleton(() => AuthSelectedTypeCubit());

  // Email Auth Bloc
  getIt.registerFactory(() => EmailAuthBloc(getIt<GraphQLService>()));

  // User Auth Bloc
  getIt.registerFactory(() => UserAuthBloc(getIt<GraphQLService>()));
}
